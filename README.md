# purescript-yaml

```purescript
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
```

## Decode YAML

Write functions to read your data from foreign values.

```purescript
readPoint :: Foreign -> F Point
readPoint value = do
  x <- readInt =<< readProp "X" value
  y <- readInt =<< readProp "Y" value
  pure $ Point x y

readMobility :: Foreign -> F Mobility
readMobility value = do
  mob <- readString value
  case mob of
      "Fix" -> pure Fix
      "Flex" -> pure Flex
      _ -> fail $ JSONError "Mobility must be either Flex or Fix"

readGeoObject :: Foreign -> F GeoObject
readGeoObject value = do
  name <- readString =<< readProp "Name"  value
  scale <- readNumber =<< readProp "Scale"  value
  points <- traverse readPoint =<< readArray =<< readProp "Points"  value
  mobility <- readMobility =<< readProp "Mobility"  value
  coverage <- readNumber =<< readProp "Coverage"  value
  pure $ GeoObject { name, scale, points, mobility, coverage }

```

Read the YAML into your data structures.

```purescript
yamlInput :: String
yamlInput = """
- Name: House
  Scale: 9.5
  Points:
  - X: 10
    Y: 10
  - X: 20
    Y: 10
  - X: 5
    Y: 5
  Mobility: Fix
  Coverage: 10
- Name: Tree
  Scale: 1
  Points:
  - X: 1
    Y: 1
  - X: 2
    Y: 2
  - X: 0
    Y: 0
  Mobility: Fix
  Coverage: 10
"""

let decoded =
      (parseYAML yamlInput) >>=
      readArray >>=
      traverse readGeoObject
```

## Encode YAML

```purescript
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
```

```purescript
data :: Array GeoObject
data =
    [ GeoObject
        { coverage: 10.0
        , mobility: Fix
        , name: "House"
        , points: [ Point 10 10, Point 20 10, Point 5 5 ]
        , scale: 9.5
        }
    , GeoObject
        { coverage: 10.0
        , mobility: Fix
        , name: "Tree"
        , points: [ Point 1 1, Point 2 2, Point 0 0 ]
        , scale: 1.0
        }
    ]

encoded = printYAML data
```
