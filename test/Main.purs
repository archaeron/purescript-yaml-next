module Test.Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Data.Foreign (F, readArray)
import Data.YAML.Foreign.Decode (parseYAML)
import Data.YAML.Foreign.Encode (printYAML)
import Data.Traversable (traverse)
import Prelude (Unit, bind, ($), void, discard, (>>=))
import Test.Instances (readGeoObject, readMobility, readPoint, GeoObject(..), Mobility(..), Point(..))
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (RunnerEffects, run)
import Control.Monad.Eff.Console (log, CONSOLE)
import Data.Map as Map
import Data.Map (Map)
import Data.StrMap as StrMap
import Data.StrMap (StrMap)

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
      'Y': 10
    - X: 20
      'Y': 10
    - X: 5
      'Y': 5
  Coverage: 10
  Name: House
  Scale: 9.5
- Mobility: Fix
  Points:
    - X: 1
      'Y': 1
    - X: 2
      'Y': 2
    - X: 0
      'Y': 0
  Coverage: 10
  Name: Tree
  Scale: 1
"""


yamlMapOutput :: String
yamlMapOutput = """key:
  - Mobility: Fix
    Points:
      - X: 10
        'Y': 10
      - X: 20
        'Y': 10
      - X: 5
        'Y': 5
    Coverage: 10
    Name: House
    Scale: 9.5
  - Mobility: Fix
    Points:
      - X: 1
        'Y': 1
      - X: 2
        'Y': 2
      - X: 0
        'Y': 0
    Coverage: 10
    Name: Tree
    Scale: 1
"""

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

main :: Eff (RunnerEffects ()) Unit
main = run [consoleReporter] do
  describe "purescript-yaml" do
    describe "decode" do
      it "Decodes YAML" do
        let decoded =
              (parseYAML yamlInput) >>=
              readArray >>=
              traverse readGeoObject
        (runExcept decoded) `shouldEqual` (Right parsedData)
    describe "encode" do
      it "Encodes YAML" $ do
        let encoded = printYAML parsedData
        encoded `shouldEqual` yamlOutput

        let encodedStrMap = printYAML testStrMap
        encodedStrMap `shouldEqual` yamlMapOutput

        let encodedMap = printYAML testMap
        encodedMap `shouldEqual` yamlMapOutput
