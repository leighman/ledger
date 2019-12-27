module Ledger where

import Prelude
import Data.Array ((:), foldl)
import Data.Int (floor)
import Data.Map (Map, fromFoldable, update)
import Data.Maybe (Maybe(..))
import Data.JSDate (now, toISOString)
import Data.Tuple (Tuple(..))
import Data.UUID (UUID, genUUID)
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Persistence (PersistedAccount)

newtype AccountId
  = AccountId Int

derive newtype instance eqAccountId :: Eq AccountId

derive newtype instance ordAccountId :: Ord AccountId

derive newtype instance showAccountId :: Show AccountId

type AccountInfo
  = { id :: AccountId
    , name :: String
    , balance :: Int
    }

type Transaction
  = { id :: UUID
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
  [ { id: unsafePerformEffect genUUID
    , utc: "2019-12-23"
    , description: "Christmas presents"
    , fromAccountId: AccountId 1
    , toAccountId: AccountId 2
    , amount: 5043
    }
  , { id: unsafePerformEffect genUUID
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

initAccounts :: Array PersistedAccount -> Array Transaction -> Map AccountId AccountInfo
initAccounts accounts transactions =
  let
    initialMap = fromFoldable (map toMapShape accounts)
  in
    foldl updateBalances initialMap transactions
  where
  toMapShape :: PersistedAccount -> Tuple AccountId AccountInfo
  toMapShape { id, name } = Tuple (AccountId id) { id: AccountId id, name, balance: 0 }

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
