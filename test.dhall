let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "test/**/*.purs" ],
  dependencies = conf.dependencies # [
    , "spec"
    , "aff"
    , "arrays"
    , "either"
    , "lists"
    , "maybe"
    , "prelude"
    , "transformers"
    , "tuples"
    ]
}
