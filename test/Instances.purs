module Test.Instances where

import Data.YAML.Foreign.Encode
import Data.Argonaut.Core (toObject, toString)
import Data.Argonaut.Decode (getField)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Either (Either(..))
import Data.Generic (class Generic, gShow, gEq)
import Data.Maybe (maybe)
import Prelude (class Eq, class Show, bind, pure, ($))

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

instance geoJson :: DecodeJson GeoObject where
  decodeJson s = do
    obj <- maybe (Left "GeoObject is not an object.") Right (toObject s)
    name <- getField obj "Name"
    scale <- getField obj "Scale"
    points <- getField obj "Points"
    mobility <- getField obj "Mobility"
    coverage <- getField obj "Coverage"
    pure $ GeoObject { name, scale, points, mobility, coverage }

instance mobilityJson :: DecodeJson Mobility where
  decodeJson s = do
    mob <- maybe (Left "Mobility is not a string.") Right (toString s)
    case mob of
        "Fix" -> pure Fix
        "Flex" -> pure Flex
        _ -> Left "Mobility must be either Flex or Fix"

instance pointJson :: DecodeJson Point where
  decodeJson s = do
    obj <- maybe (Left "Point is not an object.") Right (toObject s)
    x <- getField obj "X"
    y <- getField obj "Y"
    pure $ Point x y


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
