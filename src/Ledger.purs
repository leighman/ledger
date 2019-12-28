module Ledger where

import Prelude
import Data.Array ((:))
import Data.Int (floor)
import Data.Map (Map, update)
import Data.Maybe (Maybe(..))
import Data.JSDate (now, toISOString)
import Effect (Effect)
import Types (AccountId, AccountInfo, Ledger, Transaction)
import UUID (genUUID)

updateBalances :: Map AccountId AccountInfo -> Transaction -> Map AccountId AccountInfo
updateBalances m transaction =
  -- Is there a better way than nested update?
  update (\x -> Just (x { balance = x.balance + transaction.amount })) transaction.toAccountId
    $ update (\x -> Just (x { balance = x.balance - transaction.amount })) transaction.fromAccountId m

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
