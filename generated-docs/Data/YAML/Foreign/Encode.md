## Module Data.YAML.Foreign.Encode

#### `YValue`

``` purescript
data YValue
```

##### Instances
``` purescript
Show YValue
Eq YValue
```

#### `ToYAML`

``` purescript
class ToYAML a  where
  toYAML :: a -> YValue
```

##### Instances
``` purescript
(ToYAML a) => ToYAML (StrMap a)
(ToYAML a) => ToYAML (Map String a)
ToYAML Boolean
ToYAML Int
ToYAML Number
ToYAML String
(ToYAML a) => ToYAML (Array a)
(ToYAML a) => ToYAML (Maybe a)
```

#### `entry`

``` purescript
entry :: forall a. ToYAML a => String -> a -> Pair
```

Helper function to create a key-value tuple for a YAML object.

`name = "Name" := "This is the name"`

#### `(:=)`

``` purescript
infixl 4 entry as :=
```

#### `object`

``` purescript
object :: Array Pair -> YValue
```

Helper function to create a YAML object.

`obj = object [ "Name" := "This is the name", "Size" := 1.5 ]`

#### `printYAML`

``` purescript
printYAML :: forall a. ToYAML a => a -> String
```


