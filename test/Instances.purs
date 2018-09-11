module Test.Instances where

import Data.YAML.Foreign.Encode
import Data.Argonaut.Core (toObject, toString)
import Data.Argonaut.Decode (getField)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
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

derive instance genericGeoObject :: Generic GeoObject _
instance showGeoObject :: Show GeoObject where show = genericShow
instance eqGeoObject :: Eq GeoObject where eq = genericEq

derive instance genericPoint :: Generic Point _
instance showPoint :: Show Point where show = genericShow
instance eqPoint :: Eq Point where eq = genericEq

derive instance genericMobility :: Generic Mobility _
instance showMobility :: Show Mobility where show = genericShow
instance eqMobility :: Eq Mobility where eq = genericEq

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
