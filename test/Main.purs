module Test.Main where

import Data.Map as Map
import Data.StrMap as StrMap
import Control.Monad.Eff (Eff)
import Control.Monad.Except (runExcept)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Either (Either(..))
import Data.Map (Map)
import Data.StrMap (StrMap)
import Data.YAML.Foreign.Decode (parseYAMLToJson)
import Data.YAML.Foreign.Encode (printYAML)
import Prelude (Unit, discard, pure, ($), (<<<), (>>=))
import Test.Instances (GeoObject(..), Mobility(..), Point(..))
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (RunnerEffects, run)

yamlInput :: String
yamlInput = """
- Name: House
  Scale: 9.5
  # Points describe the outer limit of an object.
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

yamlOutput :: String
yamlOutput = """- Mobility: Fix
  Points:
    - X: 10
      Y: 10
    - X: 20
      Y: 10
    - X: 5
      Y: 5
  Coverage: 10
  Name: House
  Scale: 9.5
- Mobility: Fix
  Points:
    - X: 1
      Y: 1
    - X: 2
      Y: 2
    - X: 0
      Y: 0
  Coverage: 10
  Name: Tree
  Scale: 1
"""


yamlMapOutput :: String
yamlMapOutput = """key:
  - Mobility: Fix
    Points:
      - X: 10
        Y: 10
      - X: 20
        Y: 10
      - X: 5
        Y: 5
    Coverage: 10
    Name: House
    Scale: 9.5
  - Mobility: Fix
    Points:
      - X: 1
        Y: 1
      - X: 2
        Y: 2
      - X: 0
        Y: 0
    Coverage: 10
    Name: Tree
    Scale: 1
"""

pointYaml :: String
pointYaml = """X: 1
Y: 1
"""

yamlToData :: forall a. (DecodeJson a) => String -> Either String a
yamlToData s = case runExcept $ parseYAMLToJson s of
  Left err -> Left "Could not parse yaml"
  Right json -> decodeJson json

testStrMap :: StrMap (Array GeoObject)
testStrMap = StrMap.singleton "key" parsedData

testMap :: Map String (Array GeoObject)
testMap = Map.singleton "key" parsedData


parsedData :: Array GeoObject
parsedData =
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

readPoint :: String -> Either String Point
readPoint = yamlToData

fullCircle :: String -> Either String String
fullCircle yamlString = (readPoint yamlString) >>= pure <<< printYAML

main :: Eff (RunnerEffects ()) Unit
main = run [consoleReporter] do
  describe "purescript-yaml" do
    describe "decode" do
      it "Decodes YAML" do
        let decoded = yamlToData yamlInput
        decoded `shouldEqual` (Right parsedData)
    describe "encode" do
      it "Encodes YAML" $ do
        let encoded = printYAML parsedData
        encoded `shouldEqual` yamlOutput

        let encodedStrMap = printYAML testStrMap
        encodedStrMap `shouldEqual` yamlMapOutput

        let encodedMap = printYAML testMap
        encodedMap `shouldEqual` yamlMapOutput

        let s = fullCircle pointYaml
        s `shouldEqual` (Right pointYaml)
