## Module Data.YAML.Foreign.Encode

#### `YObject`

``` purescript
type YObject = Map String YValue
```

#### `YArray`

``` purescript
type YArray = Array YValue
```

#### `YAML`

``` purescript
data YAML :: Type
```

#### `YValue`

``` purescript
data YValue
  = YObject YObject
  | YArray YArray
  | YString String
  | YNumber Number
  | YInt Int
  | YBoolean Boolean
  | YNull
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
ToYAML Boolean
ToYAML Int
ToYAML Number
ToYAML String
(ToYAML a) => ToYAML (Array a)
(ToYAML a) => ToYAML (Maybe a)
```

#### `Pair`

``` purescript
type Pair = Tuple String YValue
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

#### `jsNull`

``` purescript
jsNull :: YAML
```

#### `objToHash`

``` purescript
objToHash :: Fn4 (YValue -> YAML) (Tuple String YValue -> String) (Tuple String YValue -> YValue) (Array (Tuple String YValue)) YAML
```

#### `valueToYAML`

``` purescript
valueToYAML :: YValue -> YAML
```

#### `toYAMLImpl`

``` purescript
toYAMLImpl :: YAML -> String
```

#### `printYAML`

``` purescript
printYAML :: forall a. ToYAML a => a -> String
```


