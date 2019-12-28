module Test.Persistence where

import Prelude
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Stub (stubLedger)
import Persistence (ledgerToJson, toPersistShape)

expected :: String
expected = "{\"accounts\":[{\"name\":\"Job\",\"id\":0},{\"name\":\"Checking\",\"id\":1},{\"name\":\"Expenses\",\"id\":2}],\"transactions\":[{\"utc\":\"2019-12-23\",\"toAccountId\":2,\"id\":\"a983f8fe-53b7-4f22-b69e-6a2985a87d79\",\"fromAccountId\":1,\"description\":\"Christmas presents\",\"amount\":5043},{\"utc\":\"2019-12-01\",\"toAccountId\":1,\"id\":\"7c96cdb9-a2c9-406d-a70b-3a0e7d6c85de\",\"fromAccountId\":0,\"description\":\"Salary\",\"amount\":200000}]}"

testPersistence :: Spec Unit
testPersistence = do
  describe "json" do
    it "encodes correctly" do
      let
        json = ledgerToJson (toPersistShape stubLedger)
        res = Right json == jsonParser expected
      res `shouldEqual` true
