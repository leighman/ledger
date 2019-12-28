module Test.Stub where

import Persistence (initAccounts)
import Types (AccountId(..), Ledger, PersistAccount, Transaction)
import UUID (unsafeUUID)

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

stubLedger :: Ledger
stubLedger =
  { accounts: initAccounts stubKnownAccounts stubTransactions
  , transactions: stubTransactions
  }
