module Main exposing (..)

import ElmTest exposing (..)
import ElmTestBDDStyle exposing (describe, it, expect, toBe)
import Account.UpdateSpec
import Account.ModelSpec
import DateTime.View.TimeDifferenceSpec
import Accounts.ModelSpec


simpleTests : List Test
simpleTests =
    [ Account.UpdateSpec.tests
    , Account.ModelSpec.tests
    , DateTime.View.TimeDifferenceSpec.tests
    , Accounts.ModelSpec.tests
    ]


main : Program Never
main =
    runSuite (describe "Elm Tests" <| simpleTests)
