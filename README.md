# purescript-yaml-next

## Install

```
spago install yaml-next
```


## YAML to Data Type Usage

Assuming we have the following `Point` data type and YAML string...

```purescript
data Point = Point Int Int

yamlPoint :: String
yamlPoint = """
X: 1
Y: 1
"""
```

We can read a `Point` from the YAML by converting the YAML into JSON
and then using [purescript-argonaut]'s encoding functionality to get the
type we need (specifically, [purescript-argonaut-codecs]
functionality).

[purescript-argonaut]: https://github.com/purescript-contrib/purescript-argonaut
[purescript-argonaut-codecs]:
    https://github.com/purescript-contrib/purescript-argonaut-codecs

```purescript
getPoint :: Either String Point
getPoint = case runExcept $ parseYAMLToJson yamlPoint of
  Left err -> Left "Could not parse yaml"
  Right json -> decodeJson json

instance pointJson :: DecodeJson Point where
  decodeJson s = do
    obj <- maybe (Left "Point is not an object.") Right (toObject s)
    x <- getField obj "X"
    y <- getField obj "Y"
    pure $ Point x y
```


## Data Type to YAML Usage

YAML is represented with the following data type.

```purescript
data YValue
    = YObject (M.Map String YValue)
    | YArray (Array YValue)
    | YString String
    | YNumber Number
    | YInt Int
    | YBoolean Boolean
    | YNull
```

To convert data into a `YValue`, create instances of the `ToYAML` class for your
data types.

```purescript
class ToYAML a where
    toYAML :: a -> YValue
```

For example to take a `Point` to `YValue`

```purescript
import Data.YAML.Foreign.Encode (object, entry, class ToYAML)

instance pointToYAML :: ToYAML Point where
    toYAML (Point x y) =
        object
            [ "X" `entry` x
            , "Y" `entry` y
            ]
```

You can find helper functions for converting basic types into `YValue`
in the `Data.YAML.Foreign.Encode` module.

Finally, if you want to convert `YValue` into a String, you can use the
`printYAML` function from `Data.YAML.Foreign.Encode`.


```purescript
printYAML :: forall a. (ToYAML a) => a -> String
```


## Summary

Using the previous code and the type classes we defined earlier,
we can go full circle from a YAML string to a PureScript Data Type
and back to a YAML string.

```purescript
fullCircle :: String -> Either String String
fullCircle yamlString = (readPoint yamlString) >>= pure <<< printYAML
```


## Contributing

1. Check out the repo
1. Run `npm install`
1. Make changes
1. Test them by running `npm test`
