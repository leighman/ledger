{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
    [ "argonaut-codecs"
    , "argonaut-core"
    , "console"
    , "effect"
    , "js-date"
    , "newtype"
    , "node-readline"
    , "optparse"
    , "ordered-collections"
    , "psci-support"
    , "spec"
    , "tuples"
    , "uuid"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
