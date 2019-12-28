module Ledger where

import Prelude
import Data.Array ((:), foldl)
import Data.Int (floor)
import Data.Map (Map, fromFoldable, update)
import Data.Maybe (Maybe(..))
import Data.JSDate (now, toISOString)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Persistence (PersistAccount)
import Types (AccountId(..), AccountInfo, Ledger, Transaction)
import UUID (genUUID, unsafeUUID)

stubKnownAccounts :: Array PersistAccount
stubKnownAccounts =
  [ { id: AccountId 0, name: "Job" }
  , { id: AccountId 1, name: "Checking" }
  , { id: AccountId 2, name: "Expenses" }
  ]

stubTransactions :: Array Transaction
stubTransactions =
  [ { id: unsafeUUID "a983f8fe-53b7-4f22-b69e-6a2985a87d79"
    , utc: "2019-12-23"
    , description: "Christmas presents"
    , fromAccountId: AccountId 1
    , toAccountId: AccountId 2
    , amount: 5043
    }
  , { id: unsafeUUID "7c96cdb9-a2c9-406d-a70b-3a0e7d6c85de"
    , utc: "2019-12-01"
    , description: "Salary"
    , fromAccountId: AccountId 0
    , toAccountId: AccountId 1
    , amount: 200000
    }
  ]

updateBalances :: Map AccountId AccountInfo -> Transaction -> Map AccountId AccountInfo
updateBalances m transaction =
  -- Is there a better way than nested update?
  update (\x -> Just (x { balance = x.balance + transaction.amount })) transaction.toAccountId
    $ update (\x -> Just (x { balance = x.balance - transaction.amount })) transaction.fromAccountId m

initAccounts :: Array PersistAccount -> Array Transaction -> Map AccountId AccountInfo
initAccounts accounts transactions =
  let
    initialMap = fromFoldable (map toMapShape accounts)
  in
    foldl updateBalances initialMap transactions
  where
  toMapShape :: PersistAccount -> Tuple AccountId AccountInfo
  toMapShape { id, name } = Tuple id { id, name, balance: 0 }

addTransaction :: Ledger -> AccountId -> AccountId -> Number -> String -> Effect Ledger
addTransaction currentState fromAccountId toAccountId amount description = do
  id <- genUUID
  utc <- toISOString =<< now
  let
    transaction =
      { id
      , utc
      , fromAccountId
      , toAccountId
      , amount: floor $ amount * 100.0
      , description
      }

    newState =
      { transactions: transaction : currentState.transactions
      , accounts: updateBalances currentState.accounts transaction
      }
  pure newState

initialState :: Ledger
initialState =
  { accounts: initAccounts stubKnownAccounts stubTransactions
  , transactions: stubTransactions
  }
