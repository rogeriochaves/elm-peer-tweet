module Main (..) where

import Task exposing (Task, andThen, sequence)
import Console exposing (run, putStrLn, (>>>))
import Graphics.Element exposing (Element, show)
import ElmTest exposing (..)
import Effects exposing (Never)
import Signal.Extra exposing (combine)
import ElmTestBDDStyle exposing (describe, it, expect, toBe)
import SignalConcatMap exposing ((>>=))


-- import Account.UpdateSpec

import Account.ModelSpec
import DateTime.View.TimeDifferenceSpec
import Download.EffectsSpec
import Publish.EffectsSpec


simpleTests : List Test
simpleTests =
  [ --Account.UpdateSpec.tests
    Account.ModelSpec.tests
  , DateTime.View.TimeDifferenceSpec.tests
  ]


effectsTests : List (Signal (Task Never Test))
effectsTests =
  [ Download.EffectsSpec.tests
  , Publish.EffectsSpec.tests
  ]


testsMailbox : Signal.Mailbox (Maybe Test)
testsMailbox =
  Signal.mailbox Nothing


port tasks : Signal (Task.Task Never ())
port tasks =
  combine effectsTests
    |> Signal.map solveEffects


solveEffects : List (Task Never Test) -> Task Never ()
solveEffects effects =
  sequence effects `andThen` signalTests


signalTests : List Test -> Task Never ()
signalTests =
  List.append simpleTests >> describe "Elm Tests" >> Just >> Signal.send testsMailbox.address


main : Signal Element
main =
  Signal.map (Maybe.map elementRunner >> Maybe.withDefault (show "Running tests")) testsMailbox.signal


port runner : Signal (Task.Task x ())
port runner =
  let
    command tests =
      case tests of
        Just tests ->
          Console.run <| (putStrLn "" >>> putStrLn "" >>> consoleRunner tests)

        Nothing ->
          Console.run <| (putStrLn "Wait...")
  in
    testsMailbox.signal >>= command
