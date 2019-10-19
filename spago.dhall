{ name =
    "yaml-next"
, dependencies =
    [ "argonaut-codecs"
    , "argonaut-core"
    , "console"
    , "effect"
    , "foreign"
    , "foreign-generic"
    , "functions"
    , "ordered-collections"
    , "psci-support"
    , "spec"
    , "unsafe-coerce"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
