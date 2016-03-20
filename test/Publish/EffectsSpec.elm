module Publish.EffectsSpec (..) where

import Publish.Effects exposing (effects)
import Model as RootModel
import Account.Model as Account
import Action exposing (..)
import Publish.Action exposing (..)
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
    { initialModel | head = { head | hash = "user" } }


model : RootModel.Model
model =
  let
    initialModel =
      fst <| RootModel.initialModel "/" (Just "user")
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
                action =
                  ActionForPublish BeginPublish

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishHead userAccount.head) ]
        , signalIt "forwards publish head actions to javascript mailbox"
            <| let
                head =
                  { hash = "uno", d = 1, next = [ "duo" ], f = [] }

                action =
                  (ActionForPublish <| PublishHead head)

                account =
                  setup model action
               in
                expectSignal ( account.jsSignal, account.task ) toBe (ActionForPublish <| PublishHead head)
        , signalIt "dispatches publish action for the next tweets"
            <| let
                head =
                  { hash = "uno", d = 1, next = [ "foo" ], f = [] }

                nextTweet =
                  { hash = "foo", d = 2, t = "something", next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | head = head, tweets = [ nextTweet ] } ] }

                action =
                  (ActionForPublish <| PublishHead head)

                account =
                  setup setupModel action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishTweet { headHash = "uno", tweet = nextTweet }) ]
        , signalIt "dispatches publish action for the next followBlocks"
            <| let
                head =
                  { hash = "uno", d = 1, next = [], f = [ "foo" ] }

                nextFollowBlock =
                  { hash = "foo", l = [ "somebody" ], next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | head = head, followBlocks = [ nextFollowBlock ] } ] }

                action =
                  (ActionForPublish <| PublishHead head)

                account =
                  setup setupModel action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishFollowBlock { headHash = "uno", followBlock = nextFollowBlock }) ]
        ]
    , signalDescribe
        "Tweet Publish"
        [ signalIt "forwards publish tweets actions to javascript mailbox"
            <| let
                tweet =
                  { hash = "foo", d = 1, t = "something", next = [] }

                action =
                  (ActionForPublish <| PublishTweet { headHash = "user", tweet = tweet })

                account =
                  setup model action
               in
                expectSignal ( account.jsSignal, account.task ) toBe action
        , signalIt "dispatches publish action for the next item"
            <| let
                tweet =
                  { hash = "foo", d = 1, t = "something", next = [ "bar" ] }

                nextTweet =
                  { hash = "bar", d = 2, t = "something else", next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | tweets = [ tweet, nextTweet ] } ] }

                action =
                  (ActionForPublish <| PublishTweet { headHash = "user", tweet = tweet })

                account =
                  setup setupModel action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishTweet { headHash = "user", tweet = nextTweet }) ]
        ]
    , signalDescribe
        "FollowBlock Publish"
        [ signalIt "forwards publish followBlocks actions to javascript mailbox"
            <| let
                followBlock =
                  { hash = "foo", l = [ "bar" ], next = [] }

                action =
                  (ActionForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup model action
               in
                expectSignal ( account.jsSignal, account.task ) toBe action
        , signalIt "dispatches publish action for the next item"
            <| let
                followBlock =
                  { hash = "foo", l = [ "uno" ], next = [ "bar" ] }

                nextFollowBlock =
                  { hash = "bar", l = [ "duo" ], next = [] }

                setupModel =
                  { model | accounts = [ { userAccount | followBlocks = [ followBlock, nextFollowBlock ] } ] }

                action =
                  (ActionForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup setupModel action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishFollowBlock { headHash = "user", followBlock = nextFollowBlock }) ]
        , signalIt "publishes the user followers"
            <| let
                followBlock =
                  { hash = "foo", l = [ "batman" ], next = [] }

                batman =
                  { hash = "batman", d = 1, next = [], f = [] }

                initialAccount =
                  Account.initialModel

                setupModel =
                  { model | accounts = [ { initialAccount | head = batman } ] }

                action =
                  (ActionForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup setupModel action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishHead batman) ]
        , signalIt "does not publish follower if it is not being followed by the user"
            <| let
                followBlock =
                  { hash = "foo", l = [ "batman" ], next = [] }

                batman =
                  { hash = "batman", d = 1, next = [], f = [] }

                initialAccount =
                  Account.initialModel

                setupModel =
                  { model | accounts = [ { initialAccount | head = batman } ] }

                action =
                  (ActionForPublish <| PublishFollowBlock { headHash = "somebody else", followBlock = followBlock })

                account =
                  setup setupModel action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ NoOp ]
        ]
    ]
