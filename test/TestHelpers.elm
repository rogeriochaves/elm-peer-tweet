module TestHelpers where

import ElmTestBDDStyle exposing (..)
import ElmTest exposing (Assertion)
import Task exposing (Task, andThen, sequence)
import Signal exposing (map, constant)
import Signal.Extra exposing (combine)

expectSignal : (Signal c, Task a b) -> (c -> d -> Bool) -> d -> Signal (Task a Assertion)
expectSignal (signal, task) toBe expected =
  signal
    |> map (\value ->
         task `andThen` (always <| Task.succeed <| expect value toBe expected)
       )

expectTask : Task a b -> (b -> c -> Bool) -> c -> Signal (Task a Assertion)
expectTask task toBe expected =
  task `andThen` (\value -> Task.succeed <| expect value toBe expected)
    |> constant

signalIt : String -> Signal (Task a Assertion) -> Signal (Task a Test)
signalIt description taskSignal =
  taskSignal
    |> map (Task.map <| it description)

signalDescribe : String -> List (Signal (Task a Test)) -> Signal (Task a Test)
signalDescribe description testsSignals =
  testsSignals
    |> combine
    |> map (Task.sequence >> (Task.map <| describe description))
