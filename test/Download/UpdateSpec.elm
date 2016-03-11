module Download.UpdateSpec where

import Download.Update exposing (effects)
import Account.Model exposing (Model, initialModel)
import Action exposing (..)
import Download.Action exposing (..)
import ElmTestBDDStyle exposing (..)
import Effects exposing (toTask)
import Task exposing (Task, andThen, sequence)
import TestHelpers exposing (expectSignal, signalIt, signalDescribe, expectTask)

setup : Model -> Action.Action -> { jsSignal : Signal Action.Action, actionsSignal : Signal (List Action.Action), task : Task Effects.Never () }
setup model action =
  let
    jsMailbox = Signal.mailbox NoOp
    actionsMailbox = Signal.mailbox [NoOp]
    effect = effects jsMailbox.address action model
  in
    { jsSignal = jsMailbox.signal
    , actionsSignal = actionsMailbox.signal
    , task = toTask actionsMailbox.address (effect)
    }

tests : Signal (Task Effects.Never Test)
tests =
  signalDescribe "Download.Update"
    [ signalDescribe "Head Download"
        [ signalIt "forwards download head actions to javascript mailbox" <|
            let
              model = initialModel
              action = (ActionForDownload <| DownloadHead "foo")
              account = setup model action
            in
              expectSignal (account.jsSignal, account.task) toBe (ActionForDownload <| DownloadHead "foo")

        , signalIt "dispatches next tweet download after a head download is done" <|
            let
              model = initialModel
              action = (ActionForDownload <| DoneDownloadHead { hash = "uno", d = 1, next = ["duo"], f = [] })
              account = setup model action
            in
              expectSignal (account.actionsSignal, account.task) toBe [(ActionForDownload <| DownloadTweet "duo")]
        ]

    , signalDescribe "Tweet Download"
        [ signalIt "forwards download tweets actions to javascript mailbox" <|
            let
              model = { initialModel | tweets = [ { hash = "foo", d = 1, t = "something", next = ["bar"] } ] }
              action = (ActionForDownload <| DownloadTweet "foo")
              account = setup model action
            in
              expectSignal (account.jsSignal, account.task) toBe (ActionForDownload <| DownloadTweet "bar")

        , signalIt "forwards NoOp actions when there is no next hash" <|
            let
              model = { initialModel | tweets = [ { hash = "foo", d = 1, t = "something", next = [] } ] }
              action = (ActionForDownload <| DownloadTweet "foo")
              account = setup model action
            in
              expectSignal (account.jsSignal, account.task) toBe (NoOp)

        , signalIt "dispatches next tweet download after a tweet download is done" <|
            let
              model = initialModel
              action = (ActionForDownload <| DoneDownloadTweet { hash = "uno", d = 1, t = "something", next = ["duo"] })
              account = setup model action
            in
              expectSignal (account.actionsSignal, account.task) toBe [(ActionForDownload <| DownloadTweet "duo")]
        ]
    ]
