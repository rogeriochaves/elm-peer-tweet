module Publish.EffectsSpec exposing (..)

import Publish.Effects exposing (effects)
import Model as RootModel
import Account.Model as Account
import Msg exposing (..)
import Publish.Msg exposing (..)
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
    { initialModel | head = { head | hash = "user" } }


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
    "Publish.Effects"
    [ signalDescribe
        "Head Publish"
        [ signalIt "starts publishing from account head"
            <| let
                msg =
                  MsgForPublish BeginPublish

                account =
                  setup model msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForPublish <| PublishHead userAccount.head) ]
        , signalIt "forwards publish head msgs to javascript mailbox"
            <| let
                head =
                  { hash = "uno", d = 1, next = [ "duo" ], f = [], n = "Mr Foo", a = "" }

                msg =
                  (MsgForPublish <| PublishHead head)

                account =
                  setup model msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe (MsgForPublish <| PublishHead head)
        , signalIt "dispatches publish msg for the next tweets"
            <| let
                head =
                  { hash = "uno", d = 1, next = [ "foo" ], f = [], n = "Mr Foo", a = "" }

                nextTweet =
                  { hash = "foo", d = 2, t = "something", next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | head = head, tweets = [ nextTweet ] } ] }

                msg =
                  (MsgForPublish <| PublishHead head)

                account =
                  setup setupModel msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForPublish <| PublishTweet { headHash = "uno", tweet = nextTweet }) ]
        , signalIt "dispatches publish msg for the next followBlocks"
            <| let
                head =
                  { hash = "uno", d = 1, next = [], f = [ "foo" ], n = "Mr Foo", a = "" }

                nextFollowBlock =
                  { hash = "foo", l = [ "somebody" ], next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | head = head, followBlocks = [ nextFollowBlock ] } ] }

                msg =
                  (MsgForPublish <| PublishHead head)

                account =
                  setup setupModel msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForPublish <| PublishFollowBlock { headHash = "uno", followBlock = nextFollowBlock }) ]
        ]
    , signalDescribe
        "Tweet Publish"
        [ signalIt "forwards publish tweets msgs to javascript mailbox"
            <| let
                tweet =
                  { hash = "foo", d = 1, t = "something", next = [] }

                msg =
                  (MsgForPublish <| PublishTweet { headHash = "user", tweet = tweet })

                account =
                  setup model msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe msg
        , signalIt "dispatches publish msg for the next item"
            <| let
                tweet =
                  { hash = "foo", d = 1, t = "something", next = [ "bar" ] }

                nextTweet =
                  { hash = "bar", d = 2, t = "something else", next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | tweets = [ tweet, nextTweet ] } ] }

                msg =
                  (MsgForPublish <| PublishTweet { headHash = "user", tweet = tweet })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForPublish <| PublishTweet { headHash = "user", tweet = nextTweet }) ]
        ]
    , signalDescribe
        "FollowBlock Publish"
        [ signalIt "forwards publish followBlocks msgs to javascript mailbox"
            <| let
                followBlock =
                  { hash = "foo", l = [ "bar" ], next = [] }

                msg =
                  (MsgForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup model msg
               in
                expectSignal ( account.jsSignal, account.task ) toBe msg
        , signalIt "dispatches publish msg for the next item"
            <| let
                followBlock =
                  { hash = "foo", l = [ "uno" ], next = [ "bar" ] }

                nextFollowBlock =
                  { hash = "bar", l = [ "duo" ], next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | followBlocks = [ followBlock, nextFollowBlock ] } ] }

                msg =
                  (MsgForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForPublish <| PublishFollowBlock { headHash = "user", followBlock = nextFollowBlock }) ]
        , signalIt "publishes the user followers"
            <| let
                followBlock =
                  { hash = "foo", l = [ "batman" ], next = [] }

                batman =
                  { hash = "batman", d = 1, next = [], f = [], n = "Batman", a = "" }

                initialAccount =
                  Account.initialModel

                setupModel =
                  { model | accounts = [ { initialAccount | head = batman } ] }

                msg =
                  (MsgForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ (MsgForPublish <| PublishHead batman) ]
        , signalIt "does not publish follower if it is not being followed by the user"
            <| let
                followBlock =
                  { hash = "foo", l = [ "batman" ], next = [] }

                batman =
                  { hash = "batman", d = 1, next = [], f = [], n = "Batman", a = "" }

                initialAccount =
                  Account.initialModel

                setupModel =
                  { model | accounts = [ { initialAccount | head = batman } ] }

                msg =
                  (MsgForPublish <| PublishFollowBlock { headHash = "somebody else", followBlock = followBlock })

                account =
                  setup setupModel msg
               in
                expectSignal ( account.msgsSignal, account.task ) toBe [ NoOp ]
        ]
    ]
