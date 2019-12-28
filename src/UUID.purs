module UUID
  ( UUID
  , genUUID
  , unsafeUUID
  ) where

import Prelude
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.UUID as U
import Effect (Effect)

newtype UUID
  = UUID U.UUID

derive newtype instance eqUUID :: Eq UUID

derive newtype instance ordUUID :: Ord UUID

derive newtype instance showUUID :: Show UUID

foreign import convert :: String -> UUID -- bleurgh

instance decodeJsonUUID :: DecodeJson UUID where
  decodeJson json = do
    string <- decodeJson json
    pure (convert string)

instance encodeJsonUUID :: EncodeJson UUID where
  encodeJson (UUID inner) = encodeJson (U.toString inner)

genUUID :: Effect UUID
genUUID = UUID <$> U.genUUID

unsafeUUID :: String -> UUID
unsafeUUID = convert
