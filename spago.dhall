{ name =
    "yaml-next"
, dependencies =
    [ "argonaut-codecs"
    , "argonaut-core"
    , "console"
    , "effect"
    , "foreign"
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
