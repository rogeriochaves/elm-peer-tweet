port module Main exposing (..)

import Test exposing (Test, describe)
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)
import Account.UpdateSpec
import Account.ModelSpec
import DateTime.View.TimeDifferenceSpec
import Accounts.ModelSpec
import Download.CmdSpec


tests : Test
tests =
    describe "ElmPeerTweet tests"
        [ Account.UpdateSpec.tests
        , Account.ModelSpec.tests
        , DateTime.View.TimeDifferenceSpec.tests
        , Accounts.ModelSpec.tests
        , Download.CmdSpec.tests
        ]


main : TestProgram
main =
    run emit tests


port emit : ( String, Value ) -> Cmd msg
