module Rendering where

import Prelude
import Data.Int (toNumber)
import Data.Map (lookup, toUnfoldable)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Data.Tuple (Tuple(..))
import Math (abs)
import Ledger (AccountId(..), Ledger)

renderAccounts :: Ledger -> String
renderAccounts ledger =
  """Accounts
========
"""
    <> ( joinWith "\n"
          $ map (\(Tuple (AccountId x) v) -> show x <> " - " <> v.name <> " | " <> renderAmount v.balance)
          $ toUnfoldable ledger.accounts
      )
    <> "\n"

renderTransactions :: Ledger -> String
renderTransactions ledger =
  """Transactions
============

"""
    <> ( joinWith "\n"
          $ map renderTransaction ledger.transactions
      )
  where
  renderTransaction t = case (lookup t.fromAccountId ledger.accounts), (lookup t.toAccountId ledger.accounts) of
    Just from, Just to ->
      t.utc <> " - " <> t.description <> "\n"
        <> from.name
        <> " -> "
        <> to.name
        <> " | "
        <> (renderAmount t.amount)
        <> "\n"
    _, _ -> "\n"

renderAmount :: Int -> String
renderAmount x =
  let
    n = (toNumber x) / 100.0
  in
    if x > 0 then "$" <> show n else "- $" <> show (abs n)
