module Download.EffectsSpec exposing (..)

import Download.Effects exposing (effects)
import Model as RootModel
import Account.Model as Account
import Msg exposing (..)
import Download.Msg exposing (..)
import ElmTestBDDStyle exposing (..)
import Effects exposing (toTask)
import Task exposing (Task, andThen, sequence)
import TestHelpers exposing (expectSignal, signalIt, signalDescribe, expectTask)


setup : RootModel.Model -> Msg.Msg -> { jsSignal : Signal Msg.Msg, msgsSignal : Signal (List Msg.Msg), task : Task Effects.Never () }
setup model msg =
  let
    jsMailbox =
      Signal.mailbox NoOp

    msgsMailbox =
      Signal.mailbox [ NoOp ]

    effect =
      effects jsMailbox.address msg model
  in
    { jsSignal = jsMailbox.signal
    , msgsSignal = msgsMailbox.signal
    , task = toTask msgsMailbox.address (effect)
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
                msg =
                  (MsgForDownload BeginDownload)

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForDownload <| DownloadHead "user") ]
        , signalIt "downloads followers head hash"
            <| let
                setupModel =
                  { model | accounts = [ userAccount, someUserAccount ] }

                msg =
                  (MsgForDownload BeginDownload)

                account =
                  setup setupModel msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForDownload <| DownloadHead "someUser") ]
        ]
    , signalDescribe
        "Head Download"
        [ signalIt "forwards download head msgs to javascript mailbox"
            <| let
                msg =
                  (MsgForDownload <| DownloadHead "foo")

                account =
                  setup model msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe (MsgForDownload <| DownloadHead "foo")
        , signalIt "dispatches next tweet download after a head download is done"
            <| let
                msg =
                  (MsgForDownload <| DoneDownloadHead { hash = "uno", d = 1, next = [ "duo" ], f = [], n = "Mr Foo", a = "" })

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForDownload <| DownloadTweet { headHash = "uno", tweetHash = "duo" }) ]
        , signalIt "dispatches next followBlock download after a head download is done"
            <| let
                msg =
                  (MsgForDownload <| DoneDownloadHead { hash = "uno", d = 1, next = [], f = [ "tre" ], n = "Mr Foo", a = "" })

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForDownload <| DownloadFollowBlock { headHash = "uno", followBlockHash = "tre" }) ]
        ]
    , signalDescribe
        "Tweet Download"
        [ signalIt "forwards download tweets msgs to javascript mailbox"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | tweets = [ { hash = "foo", d = 1, t = "something", next = [ "bar" ] } ] } ] }

                msg =
                  (MsgForDownload <| DownloadTweet { headHash = "user", tweetHash = "foo" })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe (MsgForDownload <| DownloadTweet { headHash = "user", tweetHash = "bar" })
        , signalIt "forwards NoOp msgs when there is no next hash"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | tweets = [ { hash = "foo", d = 1, t = "something", next = [] } ] } ] }

                msg =
                  (MsgForDownload <| DownloadTweet { headHash = "user", tweetHash = "foo" })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe (NoOp)
        , signalIt "dispatches next tweet download after a tweet download is done"
            <| let
                msg =
                  (MsgForDownload <| DoneDownloadTweet { headHash = "user", tweet = { hash = "uno", d = 1, t = "something", next = [ "duo" ] } })

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForDownload <| DownloadTweet { headHash = "user", tweetHash = "duo" }) ]
        ]
    , signalDescribe
        "FollowBlock Download"
        [ signalIt "forwards download followBlocks msgs to javascript mailbox"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | followBlocks = [ { hash = "foo", l = [ "somebody" ], next = [ "bar" ] } ] } ] }

                msg =
                  (MsgForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "foo" })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe (MsgForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "bar" })
        , signalIt "forwards NoOp msgs when there is no next hash"
            <| let
                setupModel =
                  { model | accounts = [ { userAccount | followBlocks = [ { hash = "foo", l = [ "somebody" ], next = [] } ] } ] }

                msg =
                  (MsgForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "foo" })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe (NoOp)
        , signalIt "dispatches next followBlock download after a followBlock download is done"
            <| let
                msg =
                  (MsgForDownload <| DoneDownloadFollowBlock { headHash = "user", followBlock = { hash = "uno", l = [], next = [ "duo" ] } })

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForDownload <| DownloadFollowBlock { headHash = "user", followBlockHash = "duo" }) ]
        , signalIt "dispatches followers download after a user followBlock download is done"
            <| let
                msg =
                  (MsgForDownload <| DoneDownloadFollowBlock { headHash = "user", followBlock = { hash = "uno", l = [ "batman" ], next = [ "duo" ] } })

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForDownload <| DownloadHead "batman") ]
        , signalIt "does not dispatch followers download if the follow block is not for the logged in user"
            <| let
                msg =
                  (MsgForDownload <| DoneDownloadFollowBlock { headHash = "somebody", followBlock = { hash = "uno", l = [ "robin" ], next = [] } })

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ NoOp ]
        ]
    ]
