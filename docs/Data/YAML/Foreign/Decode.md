## Module Data.YAML.Foreign.Decode

#### `parseYAML`

``` purescript
parseYAML :: String -> F Foreign
```

Attempt to parse a YAML string, returning the result as foreign data.

#### `readYAML`

``` purescript
readYAML :: forall a. (IsForeign a) => String -> F a
```

Attempt to parse a YAML string into the datastructure you want.

#### `readYAMLGeneric`

``` purescript
readYAMLGeneric :: forall a. (Generic a) => Options -> String -> F a
```

Automatically generate a YAML parser for your data from a generic instance.


