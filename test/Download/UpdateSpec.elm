module Download.UpdateSpec where

import Download.Update exposing (effects)
import Data.Model exposing (Model, initialModel)
import Action exposing (..)
import Download.Action exposing (..)
import ElmTestBDDStyle exposing (..)
import Effects exposing (toTask)
import Task exposing (Task, andThen, sequence)
import TestHelpers exposing (signalExpect, signalIt, signalDescribe)

setup : Model -> { signal : Signal Action.Action, task : Task Effects.Never () }
setup model =
  let
    mailbox = Signal.mailbox NoOp
    dumpMailbox = Signal.mailbox [NoOp]
    action = (ActionForDownload <| DownloadTweet "foo")
    effect = effects mailbox.address action model
  in
    { signal = mailbox.signal
    , task = toTask dumpMailbox.address (effect)
    }

tests : Signal (Task Effects.Never Test)
tests =
  signalDescribe "Download.Update"
    [ signalIt "forwards download tweets actions to javascript mailbox" <|
        let
          data = setup { initialModel | tweets = [ { hash = "foo", t = "something", next = ["bar"] } ] }
        in
          signalExpect (data.signal, data.task) toBe (ActionForDownload <| DownloadTweet "bar")

    , signalIt "forwards NoOp actions when there is no next hash" <|
        let
          data = setup { initialModel | tweets = [ { hash = "foo", t = "something", next = [] } ] }
        in
          signalExpect (data.signal, data.task) toBe (NoOp)
    ]
