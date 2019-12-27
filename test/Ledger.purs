module Test.Ledger where

import Prelude
import Data.Map (lookup)
import Data.Maybe (Maybe(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Ledger (AccountId(..), Transaction, initAccounts)
import Persistence (PersistedAccount)

testLedger :: Spec Unit
testLedger = do
  describe "initAccounts" do
    let
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
    it "balances are initialised correctly" do
      let
        accounts = initAccounts stubKnownAccounts stubTransactions

        checkingBalance = (\x -> x.balance) <$> lookup (AccountId 1) accounts

        expensesBalance = (\x -> x.balance) <$> lookup (AccountId 2) accounts
      checkingBalance `shouldEqual` Just 194957
      expensesBalance `shouldEqual` Just 5043
