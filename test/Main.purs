module Test.Main where

import Prelude

import Data.Either
import Data.Foreign
import Control.Monad.Eff
import Control.Monad.Eff.Console (CONSOLE ())
import Test.Spec (describe, it)
import Test.Spec.Runner (Process (), run)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)

import Data.YAML.Foreign.Decode
import Data.YAML.Foreign.Encode
import Test.Instances

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
yamlOutput = """- Coverage: 10
  Mobility: Fix
  Name: House
  Points:
    - X: 10
      'Y': 10
    - X: 20
      'Y': 10
    - X: 5
      'Y': 5
  Scale: 9.5
- Coverage: 10
  Mobility: Fix
  Name: Tree
  Points:
    - X: 1
      'Y': 1
    - X: 2
      'Y': 2
    - X: 0
      'Y': 0
  Scale: 1
"""

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

main :: Eff (console :: CONSOLE, process :: Process) Unit
main = run [consoleReporter] do
  describe "purescript-yaml" do
    describe "decode" do
      it "Decodes YAML" do
        let decoded = (readYAML yamlInput) :: F (Array GeoObject)
        decoded `shouldEqual` (Right parsedData)
    describe "encode" do
      it "Encodes YAML" $ do
        let encoded = printYAML parsedData
        encoded `shouldEqual` yamlOutput
