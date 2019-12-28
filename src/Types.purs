module Types where

import Prelude
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Map (Map)
import Data.Newtype (class Newtype)
import UUID (UUID)

newtype AccountId
  = AccountId Int

derive instance newtypeAccountId :: Newtype AccountId _

derive newtype instance eqAccountId :: Eq AccountId

derive newtype instance ordAccountId :: Ord AccountId

derive newtype instance showAccountId :: Show AccountId

derive newtype instance decodeJsonAccountId :: DecodeJson AccountId
derive newtype instance encodeJsonAccountId :: EncodeJson AccountId

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

type PersistAccount
  = { id :: AccountId
    , name :: String
    }

type PersistTransaction
  = { id :: UUID
    , utc :: String
    , description :: String
    , fromAccountId :: AccountId
    , toAccountId :: AccountId
    , amount :: Int
    }

type PersistLedger
  = { accounts :: Array PersistAccount
    , transactions :: Array PersistTransaction
    }
