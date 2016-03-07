module Download.UpdateSpec where

import Download.Update exposing (effects)
import Data.Model exposing (initialModel)
import Action exposing (..)
import Download.Action exposing (..)
import ElmTestBDDStyle exposing (..)
import Effects exposing (toTask)
import Task exposing (Task, andThen, sequence)
import TestHelpers exposing (signalExpect, signalIt, signalDescribe)

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

dumpMailbox : Signal.Mailbox (List Action.Action)
dumpMailbox = Signal.mailbox [NoOp]
