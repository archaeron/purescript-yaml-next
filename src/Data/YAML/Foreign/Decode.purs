module Data.YAML.Foreign.Decode (parseYAML, readYAML, readYAMLGeneric) where

import Control.Bind ((>=>))
import Data.Either
import Data.Foreign (Foreign (), F (), ForeignError (..))
import Data.Foreign.Class (IsForeign, read)
import Data.Foreign.Generic
import Data.Function (Fn3(), runFn3)
import Data.Generic (Generic)
import Prelude (Show, (<<<), (++), (>>=))

foreign import parseYAMLImpl :: forall r. Fn3 (String -> r) (Foreign -> r) String r

-- | Attempt to parse a YAML string, returning the result as foreign data.
parseYAML :: String -> F Foreign
parseYAML yaml = runFn3 parseYAMLImpl (Left <<< JSONError) Right yaml

-- | Attempt to parse a YAML string into the datastructure you want.
readYAML :: forall a. (IsForeign a) => String -> F a
readYAML yaml = parseYAML yaml >>= read

-- | Automatically generate a YAML parser for your data from a generic instance.
readYAMLGeneric :: forall a. (Generic a) => Options -> String -> F a
readYAMLGeneric opts = parseYAML >=> readGeneric opts
