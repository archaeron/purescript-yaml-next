module Data.YAML.Foreign.Encode (
  YValue,
  class ToYAML,
  toYAML,
  entry, (:=),
  object,
  printYAML
  ) where

import Data.Map as M
import Data.Map (Map)
import Data.Array (toUnfoldable)
import Data.Function.Uncurried (Fn4, runFn4)
import Data.List (List)
import Data.Maybe (Maybe, maybe)
import Data.Tuple (Tuple(..), fst, snd)
import Prelude (class Eq, class Show, map, show, ($), (<>), (==), (<<<))
import Unsafe.Coerce (unsafeCoerce)

type YObject = M.Map String YValue
type YArray = Array YValue
foreign import data YAML :: Type

data YValue
    = YObject YObject
    | YArray YArray
    | YString String
    | YNumber Number
    | YInt Int
    | YBoolean Boolean
    | YNull

instance showYValue :: Show YValue where
    show (YObject m) = "YObject " <> show m
    show (YArray vs) = "YArray " <> show vs
    show (YString s) = "YString " <> show s
    show (YNumber n) = "YNumber " <> show n
    show (YInt i) = "YInt " <> show i
    show (YBoolean b) = "YBoolean " <> show b
    show YNull = "YNull"

instance eqYValue :: Eq YValue where
    eq (YObject a) (YObject b) = a == b
    eq (YArray a) (YArray b) = a == b
    eq (YString a) (YString b) = a == b
    eq (YNumber a) (YNumber b) = a == b
    eq (YInt a) (YInt b) = a == b
    eq (YBoolean a) (YBoolean b) = a == b
    eq YNull YNull = true
    eq _ _ = false

class ToYAML a where
    toYAML :: a -> YValue

instance mapToYAML :: (ToYAML a) => ToYAML (Map String a) where
    toYAML m = YObject $ map (\value -> toYAML value) m

instance booleanToYAML :: ToYAML Boolean where
    toYAML = YBoolean

instance intToYAML :: ToYAML Int where
    toYAML = YInt

instance numberToYAML :: ToYAML Number where
    toYAML = YNumber

instance stringToYAML :: ToYAML String where
    toYAML = YString

instance arrayToYAML :: (ToYAML a) => ToYAML (Array a) where
    toYAML = YArray <<< map toYAML

instance maybeToYAML :: (ToYAML a) => ToYAML (Maybe a) where
    toYAML = maybe YNull toYAML

type Pair = Tuple String YValue

-- | Helper function to create a key-value tuple for a YAML object.
-- |
-- | `name = "Name" := "This is the name"`
entry :: forall a. (ToYAML a) => String -> a -> Pair
entry name value = Tuple name (toYAML value)

infixl 4 entry as :=

-- | Helper function to create a YAML object.
-- |
-- | `obj = object [ "Name" := "This is the name", "Size" := 1.5 ]`
object :: Array Pair -> YValue
object ps = YObject $ M.fromFoldable (toUnfoldable ps :: List Pair)

foreign import jsNull :: YAML
foreign import objToHash ::
    Fn4 (YValue -> YAML)
        (Tuple String YValue -> String)
        (Tuple String YValue -> YValue)
        (Array (Tuple String YValue))
        YAML

valueToYAML :: YValue -> YAML
valueToYAML (YObject o) = runFn4 objToHash valueToYAML fst snd $ M.toUnfoldable o
valueToYAML (YArray a) = unsafeCoerce $ map valueToYAML a
valueToYAML (YString s) = unsafeCoerce s
valueToYAML (YNumber n) = unsafeCoerce n
valueToYAML (YInt i) = unsafeCoerce i
valueToYAML (YBoolean b) = unsafeCoerce b
valueToYAML YNull = jsNull

foreign import toYAMLImpl :: YAML -> String

printYAML :: forall a. (ToYAML a) => a -> String
printYAML = toYAMLImpl <<< valueToYAML <<< toYAML
