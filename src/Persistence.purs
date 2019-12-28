module Persistence where

import Prelude
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Argonaut.Decode.Class (decodeJson)
import Data.Argonaut.Encode.Class (encodeJson)
import Data.Array (foldl)
import Data.Either (Either(..))
import Data.Map (Map, fromFoldable, toUnfoldable)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff, throwError)
import Effect.Class (liftEffect)
import Effect.Exception (error)
import Node.Buffer (Buffer, fromString, toString)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readFile, writeFile)
import Ledger (updateBalances)
import Types (AccountId, AccountInfo, Ledger, PersistAccount, PersistLedger, Transaction)

readLedger :: Aff Ledger
readLedger = do
  b <- readFile "./ledger.json"
  s <- liftEffect $ toString UTF8 b
  let
    ledger = jsonParser s >>= ledgerFromJson
  case ledger of
    Right l -> pure $ fromPersistShape l
    Left e -> throwError $ error e

saveLedger :: Ledger -> Aff Unit
saveLedger l = do
  b <- liftEffect $ ledgerToBuffer l
  writeFile "./ledger.json" b

ledgerToBuffer :: Ledger -> Effect Buffer
ledgerToBuffer = toPersistShape >>> ledgerToJson >>> stringify >>> \s -> fromString s UTF8

toPersistShape :: Ledger -> PersistLedger
toPersistShape { accounts, transactions } =
  { accounts: map (\(Tuple _ { id, name }) -> { id, name }) $ toUnfoldable accounts
  , transactions
  }

initAccounts :: Array PersistAccount -> Array Transaction -> Map AccountId AccountInfo
initAccounts accounts transactions =
  let
    initialMap = fromFoldable (map toMapShape accounts)
  in
    foldl updateBalances initialMap transactions
  where
  toMapShape :: PersistAccount -> Tuple AccountId AccountInfo
  toMapShape { id, name } = Tuple id { id, name, balance: 0 }

fromPersistShape :: PersistLedger -> Ledger
fromPersistShape { accounts, transactions } =
  { accounts: initAccounts accounts transactions
  , transactions
  }

ledgerToJson :: PersistLedger -> Json
ledgerToJson = encodeJson

ledgerFromJson :: Json -> Either String PersistLedger
ledgerFromJson = decodeJson
