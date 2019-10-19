module Data.YAML.Foreign.Decode (
  readYAMLGeneric,
  parseYAMLToJson
  ) where

import Foreign (F, Foreign, ForeignError(..), fail)
import Foreign.Generic (genericDecode)
import Foreign.Generic.Class (class GenericDecode, Options)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Generic.Rep (class Generic)
import Prelude ((>=>), (<<<), pure, (>>=))
import Unsafe.Coerce (unsafeCoerce)
import Data.Argonaut.Core (Json)

foreign import parseYAMLImpl :: forall r. Fn3 (String -> r) (Foreign -> r) String r

-- | Attempt to parse a YAML string, returning the result as foreign data.
parseYAML :: String -> F Foreign
parseYAML yaml = runFn3 parseYAMLImpl (fail <<< ForeignError) pure yaml

-- | Attempt to parse a YAML string, returning the result as Json
parseYAMLToJson :: String -> F Json
parseYAMLToJson yaml = parseYAML yaml >>= pure <<< unsafeCoerce

-- | Automatically generate a YAML parser for your data from a generic instance.
readYAMLGeneric :: forall a rep. (Generic a rep) => (GenericDecode rep) => Options -> String -> F a
readYAMLGeneric opts = parseYAML >=> genericDecode opts
