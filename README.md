# purescript-yaml

## Install

This repo depends on js-yaml, so you'll need to install js-yaml in your
project.  It is not compatible with YAML 1.1.

```
npm install js-yaml@^3.4.6
```

Then, if you're using bower, add the this repo as a project dependency, e.g.


```
bower install git://github.com/dgendill/purescript-yaml#1.0.0
```

Or you can manually add the github repo as a project dependency, e.g.

```
"dependencies": {
  "purescript-yaml" : git://github.com/dgendill/purescript-yaml#tagOrBranch
}
```

## YAML to Data Type Usage

Assuming we have the following Point data type and yaml...


```purescript
data Point = Point Int Int

yamlPoint :: String
yamlPoint = """
X: 1
Y: 1
"""
```

We can read a `Point` from the yaml by convertion the YAML into JSON
and then using [purescript-argonaut](https://github.com/purescript-contrib/purescript-argonaut)'s encoding functionality to get the
type we need (specifically, [purescript-argonaut-codecs](https://github.com/purescript-contrib/purescript-argonaut-codecs)
functionality).

```
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

```
data YValue
    = YObject (M.Map String YValue)
    | YArray (Array YValue)
    | YString String
    | YNumber Number
    | YInt Int
    | YBoolean Boolean
    | YNull
```

To convert data into YValue, create instances of the ToYAML class for your
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
in the Data.YAML.Foreign.Encode module.

Finally, if you want to convert YValue into a String, you can use the
`printYAML` function from Data.YAML.Foreign.Encode.


```purescript
printYAML :: forall a. (ToYAML a) => a -> String
```

## Summary

Using the previous code and the type classes we defined earlier, we can go
full circle from a YAML string to a PureScript Data Type and back to a YAML string.

```
fullCircle :: String -> Either String String
fullCircle yamlString = (readPoint yamlString) >>= pure <<< printYAML
```

## Contributing

Check out the repo and make changes. You can run/add tests by running pulp test.

```
bower install
npm install
pulp test
```
