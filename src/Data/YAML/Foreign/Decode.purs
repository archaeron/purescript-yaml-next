module Data.YAML.Foreign.Decode (parseYAMLToJson)
where

import Foreign (F, Foreign, ForeignError(..), fail)
import Data.Function.Uncurried (Fn3, runFn3)
import Prelude (pure, (<<<), (>>=))
import Unsafe.Coerce (unsafeCoerce)
import Data.Argonaut.Core (Json)

foreign import parseYAMLImpl :: forall r.
  Fn3 (String -> r) (Foreign -> r) String r


-- | Attempt to parse a YAML string, returning the result as foreign data.
parseYAML :: String -> F Foreign
parseYAML yaml =
  runFn3 parseYAMLImpl (fail <<< ForeignError) pure yaml


-- | Attempt to parse a YAML string, returning the result as Json
parseYAMLToJson :: String -> F Json
parseYAMLToJson yaml =
  parseYAML yaml >>= pure <<< unsafeCoerce
