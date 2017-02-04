module Data.YAML.Foreign.Decode (parseYAML, readYAML, readYAMLGeneric) where

import Data.Foreign (F, Foreign, ForeignError(..), fail)
import Data.Foreign.Class (class IsForeign, read)
import Data.Foreign.Generic (readGeneric)
import Data.Foreign.Generic.Classes (class GenericDecode)
import Data.Foreign.Generic.Types (Options)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Generic.Rep (class Generic)
import Prelude (pure, (<<<), (>>=), (>=>))

foreign import parseYAMLImpl :: forall r. Fn3 (String -> r) (Foreign -> r) String r

-- | Attempt to parse a YAML string, returning the result as foreign data.
parseYAML :: String -> F Foreign
parseYAML yaml = runFn3 parseYAMLImpl (fail <<< JSONError) pure yaml

-- | Attempt to parse a YAML string into the datastructure you want.
readYAML :: forall a. (IsForeign a) => String -> F a
readYAML yaml = parseYAML yaml >>= read

-- | Automatically generate a YAML parser for your data from a generic instance.
readYAMLGeneric :: forall a rep. (Generic a rep, GenericDecode rep) => Options -> String -> F a
readYAMLGeneric opts = parseYAML >=> readGeneric opts

