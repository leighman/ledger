module Command where

import Prelude
import Global (isNaN, readFloat)
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), trim, split)
import Effect (Effect)
import Effect.Console (log)
import Ledger (AccountId(..), Ledger, addTransaction)
import Rendering (renderAccounts, renderTransactions)

-- should be some kind of StateT?
handleCommand :: Ledger -> String -> Effect Ledger
handleCommand currentState input = case split (Pattern " ") (trim input) of
  [ "accounts" ] -> do
    log $ renderAccounts currentState
    pure currentState
  [ "transactions" ] -> do
    log $ renderTransactions currentState
    pure currentState
  [ "add", "transaction", "from", from, "to", to, amount, description ] -> do
    let
      a = readFloat amount
    case fromString from, fromString to, isNaN a of
      Just f, Just t, false -> do
        -- TODO: smart constructor for AccountId that checks account exists
        newState <- addTransaction currentState (AccountId f) (AccountId t) a description
        log $ renderTransactions newState
        pure newState
      _, _, _ -> log "Unable to parse command" $> currentState
  _ -> do
    log "Unknown command"
    pure currentState
