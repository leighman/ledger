module Test.Ledger where

import Prelude
import Data.Map (lookup)
import Data.Maybe (Maybe(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Stub (stubLedger)
import Types (AccountId(..))

testLedger :: Spec Unit
testLedger = do
  describe "initAccounts" do
    it "balances are initialised correctly" do
      let
        { accounts } = stubLedger

        checkingBalance = (\x -> x.balance) <$> lookup (AccountId 1) accounts

        expensesBalance = (\x -> x.balance) <$> lookup (AccountId 2) accounts
      checkingBalance `shouldEqual` Just 194957
      expensesBalance `shouldEqual` Just 5043
