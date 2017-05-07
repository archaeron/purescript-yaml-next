module Test.Instances where

import Prelude (class Eq, class Show, bind, pure, ($), (=<<), (<$>), map, (<=<))
import Data.Traversable (traverse)
import Data.Foreign (readArray, readNumber, readString, readInt, F, Foreign, ForeignError(..), fail, readString)
import Data.Foreign.Index (readProp)
import Data.Generic (class Generic, gShow, gEq)
import Data.YAML.Foreign.Encode

data Point = Point Int Int

data Mobility
    = Fix
    | Flex

data GeoObject = GeoObject
    { name :: String
    , scale :: Number
    , points :: Array Point
    , mobility :: Mobility
    , coverage :: Number
    }

derive instance genericGeoObject :: Generic GeoObject
instance showGeoObject :: Show GeoObject where show = gShow
instance eqGeoObject :: Eq GeoObject where eq = gEq

derive instance genericPoint :: Generic Point
instance showPoint :: Show Point where show = gShow
instance eqPoint :: Eq Point where eq = gEq

derive instance genericMobility :: Generic Mobility
instance showMobility :: Show Mobility where show = gShow
instance eqMobility :: Eq Mobility where eq = gEq

readGeoObject :: Foreign -> F GeoObject
readGeoObject value = do
  name <- readString =<< readProp "Name"  value
  scale <- readNumber =<< readProp "Scale"  value
  points <- traverse readPoint =<< readArray =<< readProp "Points"  value
  mobility <- readMobility =<< readProp "Mobility"  value
  coverage <- readNumber =<< readProp "Coverage"  value
  pure $ GeoObject { name, scale, points, mobility, coverage }

readPoint :: Foreign -> F Point
readPoint value = do
-- instance pointIsForeign :: IsForeign Point where
--     read value = do
        x <- readInt =<< readProp "X" value
        y <- readInt =<< readProp "Y" value
        pure $ Point x y

readMobility :: Foreign -> F Mobility
readMobility value = do
-- instance mobilityIsForeign :: IsForeign Mobility where
    -- read value = do
        mob <- readString value
        case mob of
            "Fix" -> pure Fix
            "Flex" -> pure Flex
            _ -> fail $ JSONError "Mobility must be either Flex or Fix"

instance pointToYAML :: ToYAML Point where
    toYAML (Point x y) =
        object
            [ "X" := x
            , "Y" := y
            ]

instance mobilityToYAML :: ToYAML Mobility where
    toYAML Fix = toYAML "Fix"
    toYAML Flex = toYAML "Flex"

instance archiObjectToYAML :: ToYAML GeoObject where
    toYAML (GeoObject o) =
        object
            [ "Name" := o.name
            , "Scale" := o.scale
            , "Points" := o.points
            , "Mobility" := o.mobility
            , "Coverage" := o.coverage
            ]
