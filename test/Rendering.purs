module Test.Rendering where

import Prelude
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Stub (stubLedger)
import Rendering (renderAccounts, renderAmount, renderTransactions)

testRendering :: Spec Unit
testRendering = do
  describe "Rendering" do
    it "renders amounts correctly" do
      renderAmount 200000 `shouldEqual` "$2000.0"
      renderAmount (-200000) `shouldEqual` "- $2000.0"
    it "renders accounts correctly" do
      let
        expected =
          """Accounts
========
0 - Job | - $2000.0
1 - Checking | $1949.57
2 - Expenses | $50.43
"""
      renderAccounts stubLedger `shouldEqual` expected
    it "renders transactions correctly" do
      let
        expected =
          """Transactions
============

2019-12-01 - Salary
Job -> Checking | $2000.0

2019-12-23 - Christmas presents
Checking -> Expenses | $50.43
"""
      renderTransactions stubLedger `shouldEqual` expected
