module Download.UpdateSpec where

import Download.Update exposing (effects)
import Data.Model exposing (initialModel)
import Action exposing (..)
import Download.Action exposing (..)
import ElmTestBDDStyle exposing (..)
import ElmTest exposing (Assertion)
import Effects exposing (toTask)
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

dumpMailbox : Signal.Mailbox (List Action.Action)
dumpMailbox = Signal.mailbox [NoOp]

tests : Signal (Task Effects.Never Test)
tests =
  signalDescribe "Download.Update"
    [ signalIt "forwards download tweets actions to javascript mailbox" <|
        let
          mailbox = Signal.mailbox NoOp
          action = ActionForDownload (DownloadTweet "foobar")
          data = initialModel
          effect = effects mailbox.address action data
          task = toTask dumpMailbox.address (effect)
        in
          signalExpect (mailbox.signal, task) toBe (ActionForDownload <| DownloadTweet "foobar")
    ]
