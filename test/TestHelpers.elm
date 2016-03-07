module TestHelpers where

import ElmTestBDDStyle exposing (..)
import ElmTest exposing (Assertion)
import Task exposing (Task, andThen, sequence)
import Signal.Extra exposing (combine)

signalExpect : (Signal c, Task a b) -> (c -> d -> Bool) -> d -> Signal (Task a Assertion)
signalExpect (signal, task) toBe expected =
  signal
    |> Signal.map (\value ->
         task `andThen` (always <| Task.succeed <| expect value toBe expected)
       )

signalIt : String -> Signal (Task a Assertion) -> Signal (Task a Test)
signalIt description taskSignal =
  taskSignal
    |> Signal.map (Task.map <| it description)

signalDescribe : String -> List (Signal (Task a Test)) -> Signal (Task a Test)
signalDescribe description testsSignals =
  testsSignals
    |> combine
    |> Signal.map (Task.sequence >> (Task.map <| describe description))
