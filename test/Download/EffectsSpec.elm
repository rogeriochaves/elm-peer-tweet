module Download.EffectsSpec (..) where

import Download.Effects exposing (effects)
import Model as RootModel
import Account.Model as Account
import Action exposing (..)
import Download.Action exposing (..)
import ElmTestBDDStyle exposing (..)
import Effects exposing (toTask)
import Task exposing (Task, andThen, sequence)
import TestHelpers exposing (expectSignal, signalIt, signalDescribe, expectTask)


setup : RootModel.Model -> Action.Action -> { jsSignal : Signal Action.Action, actionsSignal : Signal (List Action.Action), task : Task Effects.Never () }
setup model action =
  let
    jsMailbox =
      Signal.mailbox NoOp

    actionsMailbox =
      Signal.mailbox [ NoOp ]

    effect =
      effects jsMailbox.address action model
  in
    { jsSignal = jsMailbox.signal
    , actionsSignal = actionsMailbox.signal
    , task = toTask actionsMailbox.address (effect)
    }


userAccount : Account.Model
userAccount =
  let
    initialModel =
      Account.initialModel

    head =
      initialModel.head
  in
    { initialModel
      | head = { head | hash = "user", f = ["followBlock1"] }
      , followBlocks = [{ hash = "followBlock1", l = ["someUser"], next = [] }]
    }


someUserAccount : Account.Model
someUserAccount =
  let
    initialModel =
      Account.initialModel

    head =
      initialModel.head
  in
    { initialModel | head = { head | hash = "someUser" } }


model : RootModel.Model
model =
  let
    initialModel =
      fst <| RootModel.initialModel "/" (Just "user") Nothing
  in
    { initialModel | accounts = [ userAccount ] }


tests : Signal (Task Effects.Never Test)
tests =
  signalDescribe
    "Download.Effects"
    [ signalDescribe
        "Begin Download"
        [ signalIt "downloads user hash"
            <| let
                action =
                  (ActionForDownload BeginDownload)

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForDownload <| DownloadHead "user") ]
        , signalIt "downloads followers head hash"
            <| let
                setupModel =
                  { model | accounts = [ userAccount, someUserAccount ] }

                action =
                  (ActionForDownload BeginDownload)

                account =
                  setup setupModel action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForDownload <| DownloadHead "someUser") ]
        ]
    , signalDescribe
        "Head Download"
        [ signalIt "forwards download head actions to javascript mailbox"
            <| let
                action =
                  (ActionForDownload <| DownloadHead "foo")

                account =
                  setup model action
               in
                expectSignal ( account.jsSignal, account.task ) toBe (ActionForDownload <| DownloadHead "foo")
        , signalIt "dispatches next tweet download after a head download is done"
            <| let
                action =
                  (ActionForDownload <| DoneDownloadHead { hash = "uno", d = 1, next = [ "duo" ], f = [], n = "Mr Foo", a = "" })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForDownload <| DownloadTweet { headHash = "uno", tweetHash = "duo" }) ]
        , signalIt "dispatches next followBlock download after a head download is done"
            <| let
                action =
                  (ActionForDownload <| DoneDownloadHead { hash = "uno", d = 1, next = [], f = [ "tre" ], n = "Mr Foo", a = "" })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForDownload <| DownloadFollowBlock { headHash = "uno", followBlockHash = "tre" }) ]
        ]
    , signalDescribe
        "Tweet Download"
        [ signalIt "forwards download tweets actions to javascript mailbox"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | tweets = [ { hash = "foo", d = 1, t = "something", next = [ "bar" ] } ] } ] }

                action =
                  (ActionForDownload <| DownloadTweet { headHash = "user", tweetHash = "foo" })

                account =
                  setup setupModel action
               in
                expectSignal ( account.jsSignal, account.task ) toBe (ActionForDownload <| DownloadTweet { headHash = "user", tweetHash = "bar" })
        , signalIt "forwards NoOp actions when there is no next hash"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | tweets = [ { hash = "foo", d = 1, t = "something", next = [] } ] } ] }

                action =
                  (ActionForDownload <| DownloadTweet { headHash = "user", tweetHash = "foo" })

                account =
                  setup setupModel action
               in
                expectSignal ( account.jsSignal, account.task ) toBe (NoOp)
        , signalIt "dispatches next tweet download after a tweet download is done"
            <| let
                action =
                  (ActionForDownload <| DoneDownloadTweet { headHash = "user", tweet = { hash = "uno", d = 1, t = "something", next = [ "duo" ] } })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForDownload <| DownloadTweet { headHash = "user", tweetHash = "duo" }) ]
        ]
    , signalDescribe
        "FollowBlock Download"
        [ signalIt "forwards download followBlocks actions to javascript mailbox"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | followBlocks = [ { hash = "foo", l = [ "somebody" ], next = [ "bar" ] } ] } ] }

                action =
                  (ActionForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "foo" })

                account =
                  setup setupModel action
               in
                expectSignal ( account.jsSignal, account.task ) toBe (ActionForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "bar" })
        , signalIt "forwards NoOp actions when there is no next hash"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | followBlocks = [ { hash = "foo", l = [ "somebody" ], next = [] } ] } ] }

                action =
                  (ActionForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "foo" })

                account =
                  setup setupModel action
               in
                expectSignal ( account.jsSignal, account.task ) toBe (NoOp)
        , signalIt "dispatches next followBlock download after a followBlock download is done"
            <| let
                action =
                  (ActionForDownload <| DoneDownloadFollowBlock { headHash = "user", followBlock = { hash = "uno", l = [], next = [ "duo" ] } })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "duo" }) ]
        , signalIt "dispatches followers download after a user followBlock download is done"
            <| let
                action =
                  (ActionForDownload <| DoneDownloadFollowBlock { headHash = "user", followBlock = { hash = "uno", l = [ "batman" ], next = [ "duo" ] } })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForDownload <| DownloadHead "batman") ]
        , signalIt "does not dispatch followers download if the follow block is not for the logged in user"
            <| let
                action =
                  (ActionForDownload <| DoneDownloadFollowBlock { headHash = "somebody", followBlock = { hash = "uno", l = [ "robin" ], next = [] } })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ NoOp ]
        ]
    ]
