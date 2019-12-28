module Persistence where

import Prelude
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Decode.Class (decodeJson)
import Data.Argonaut.Encode.Class (encodeJson)
import Data.Argonaut.Encode.Combinators ((:=), (~>))
import Data.Either (Either)
import Data.Map (toUnfoldable)
import Data.Tuple (Tuple(..))
import Types (AccountId, Ledger)
import UUID (UUID)

type PersistAccount
  = { id :: AccountId
    , name :: String
    }

type PersistTransaction
  = { id :: UUID
    , utc :: String
    , description :: String
    , fromAccountId :: AccountId
    , toAccountId :: AccountId
    , amount :: Int
    }

type PersistLedger
  = { accounts :: Array PersistAccount
    , transactions :: Array PersistTransaction
    }

toPersistShape :: Ledger -> PersistLedger
toPersistShape { accounts, transactions } =
  { accounts: map (\(Tuple _ {id, name}) -> {id, name}) $ toUnfoldable accounts
  , transactions
  }

ledgerToJson :: PersistLedger -> Json
ledgerToJson = encodeJson

ledgerFromJson :: Json -> Either String PersistLedger
ledgerFromJson = decodeJson
