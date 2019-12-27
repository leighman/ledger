module Test.Stub where

import Ledger (AccountId(..), Ledger, Transaction, initAccounts)
import Persistence (PersistedAccount)

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

stubLedger :: Ledger
stubLedger =
  { accounts: initAccounts stubKnownAccounts stubTransactions
  , transactions: stubTransactions
  }
