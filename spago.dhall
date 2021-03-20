{ name =
    "yaml-next"
, license = "MIT"
, repository = "https://github.com/archaeron/purescript-yaml"
, dependencies =
    [ "argonaut-codecs"
    , "argonaut-core"
    , "effect"
    , "foreign"
    , "functions"
    , "ordered-collections"
    , "unsafe-coerce"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs" ]
}
