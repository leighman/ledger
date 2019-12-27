{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
    [ "console"
    , "effect"
    , "js-date"
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
