module Command where

import Prelude
import Data.String (Pattern(..), trim, split)
import Effect (Effect)
import Effect.Console (log)
import Ledger (Ledger)
import Rendering (renderAccounts, renderTransactions)

handleCommand :: Ledger -> String -> Effect Unit
handleCommand currentState input = case split (Pattern " ") (trim input) of
  [ "accounts" ] -> log $ renderAccounts currentState
  [ "transactions" ] -> log $ renderTransactions currentState
  _ -> log "Unknown command"
