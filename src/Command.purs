module Command where

import Prelude
import Data.String (Pattern(..), split)
import Data.Tuple.Nested (get1)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Options.Applicative (Parser, ParserFailure(..), ParserResult(..), command, defaultPrefs, execParserPure, long, idm, info, int, metavar, number, option, strOption, subparser)
import Options.Applicative.Help (renderHelp)
import Ledger (addTransaction)
import Persistence (saveLedger)
import Rendering (renderAccounts, renderTransactions)
import Types (AccountId(..), Ledger)

newtype AddTransactionInfo
  = AddTransactionInfo
  { from :: Int
  , to :: Int
  , amount :: Number
  , description :: String
  }

data Command
  = Accounts
  | Transactions
  | AddTransaction AddTransactionInfo

addTransactionOpts :: Parser AddTransactionInfo
addTransactionOpts = ado
  from <- option int (long "from" <> metavar "ACCOUNT")
  to <- option int (long "to" <> metavar "ACCOUNT")
  amount <- option number (long "amount" <> metavar "AMOUNT")
  description <- strOption (long "description" <> metavar "DESCRIPTION")
  in AddTransactionInfo { from, to, amount, description }

addOpts :: Parser Command
addOpts =
  subparser
    (command "transaction" (info (AddTransaction <$> addTransactionOpts) idm))

opts :: Parser Command
opts =
  subparser
    ( command "accounts" (info (pure Accounts) idm)
        <> command "transactions" (info (pure Transactions) idm)
        <> command "add" (info addOpts idm)
    )

-- should be some kind of StateT?
handleCommand :: Ledger -> String -> Aff Ledger
handleCommand currentState input = do
  let
    res =
      execParserPure
        defaultPrefs
        (info opts idm)
        (split (Pattern " ") input)
  case res of
    Success command -> do
      case command of
        Accounts -> do
          liftEffect $ log $ renderAccounts currentState
          pure currentState
        Transactions -> do
          liftEffect $ log $ renderTransactions currentState
          pure currentState
        AddTransaction (AddTransactionInfo { amount, from, to, description }) -> do
          -- TODO: smart constructor for AccountId that checks account exists
          newState <- liftEffect $ addTransaction currentState (AccountId from) (AccountId to) amount description
          saveLedger newState
          liftEffect $ log $ renderTransactions newState
          pure newState
    Failure (ParserFailure f) -> do
      liftEffect $ log $ renderHelp 2 (get1 (f ">"))
      pure currentState
    _ -> pure currentState
