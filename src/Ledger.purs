module Ledger where

import Prelude
import Data.Array (foldl)
import Data.Map (Map, fromFoldable, update)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Persistence (PersistedAccount)

newtype AccountId
  = AccountId Int

derive newtype instance eqAccountId :: Eq AccountId

derive newtype instance ordAccountId :: Ord AccountId

type AccountInfo
  = { id :: AccountId
    , name :: String
    , balance :: Int
    }

type Transaction
  = { id :: Int
    , utc :: String
    , description :: String
    , fromAccountId :: AccountId
    , toAccountId :: AccountId
    , amount :: Int
    }

type Ledger
  = { accounts :: Map AccountId AccountInfo
    , transactions :: Array Transaction
    }

stubKnownAccounts :: Array PersistedAccount
stubKnownAccounts =
  [ { id: 0, name: "Job" }
  , { id: 1, name: "Checking" }
  , { id: 2, name: "Expenses" }
  ]

stubTransactions :: Array Transaction
stubTransactions =
  [ { id: 0
    , utc: "2019-12-01"
    , description: "Salary"
    , fromAccountId: AccountId 0
    , toAccountId: AccountId 1
    , amount: 200000
    }
  , { id: 1
    , utc: "2019-12-23"
    , description: "Christmas presents"
    , fromAccountId: AccountId 1
    , toAccountId: AccountId 2
    , amount: 5043
    }
  ]

initAccounts :: Array PersistedAccount -> Array Transaction -> Map AccountId AccountInfo
initAccounts accounts transactions =
  let
    initialMap = fromFoldable (map toMapShape accounts)

    updateBalances m transaction =
      -- Is there a better way than nested update?
      update (\x -> Just (x { balance = x.balance + transaction.amount })) transaction.toAccountId
        $ update (\x -> Just (x { balance = x.balance - transaction.amount })) transaction.fromAccountId m
  in
    foldl updateBalances initialMap transactions
  where
  toMapShape :: PersistedAccount -> Tuple AccountId AccountInfo
  toMapShape { id, name } = Tuple (AccountId id) { id: AccountId id, name, balance: 0 }

initialState :: Ledger
initialState =
  { accounts: initAccounts stubKnownAccounts stubTransactions
  , transactions: stubTransactions
  }
