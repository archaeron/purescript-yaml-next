module Test.Instances where

import Prelude
import Data.Either
import Data.Foreign
import Data.Foreign.Class
import Data.Generic (Generic, gShow, gEq)

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

instance archiObjectIsForeign :: IsForeign GeoObject where
    read value = do
        name <- readProp "Name"  value
        scale <- readProp "Scale"  value
        points <- readProp "Points"  value
        mobility <- readProp "Mobility"  value
        coverage <- readProp "Coverage"  value
        return $ GeoObject { name, scale, points, mobility, coverage }

instance pointIsForeign :: IsForeign Point where
    read value = do
        x <- readProp "X" value
        y <- readProp "Y" value
        return $ Point x y

instance mobilityIsForeign :: IsForeign Mobility where
    read value = do
        mob <- readString value
        case mob of
            "Fix" -> return Fix
            "Flex" -> return Flex
            _ -> Left $ JSONError "Mobility must be either Flex or Fix"

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
