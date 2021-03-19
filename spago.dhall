{ name =
    "yaml-next"
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
