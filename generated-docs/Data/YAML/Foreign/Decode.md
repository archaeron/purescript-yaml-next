## Module Data.YAML.Foreign.Decode

#### `parseYAMLToJson`

``` purescript
parseYAMLToJson :: String -> F Json
```

Attempt to parse a YAML string, returning the result as Json

#### `readYAMLGeneric`

``` purescript
readYAMLGeneric :: forall a rep. Generic a rep => GenericDecode rep => Options -> String -> F a
```

Automatically generate a YAML parser for your data from a generic instance.


