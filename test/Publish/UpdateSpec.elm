module Publish.UpdateSpec (..) where

import Publish.Update exposing (effects)
import Data.Model as Data exposing (Model)
import Account.Model as Account
import Action exposing (..)
import Publish.Action exposing (..)
import ElmTestBDDStyle exposing (..)
import Effects exposing (toTask)
import Task exposing (Task, andThen, sequence)
import TestHelpers exposing (expectSignal, signalIt, signalDescribe, expectTask)


setup : Model -> Action.Action -> { jsSignal : Signal Action.Action, actionsSignal : Signal (List Action.Action), task : Task Effects.Never () }
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


data : Model
data =
  let
    initialModel =
      Data.initialModel
  in
    { initialModel | hash = "user", accounts = [ userAccount ] }


tests : Signal (Task Effects.Never Test)
tests =
  signalDescribe
    "Publish.Update"
    [ signalDescribe
        "Head Publish"
        [ signalIt "starts publishing from account head"
            <| let
                action =
                  ActionForPublish BeginPublish

                account =
                  setup data action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishHead userAccount.head) ]
        , signalIt "forwards publish head actions to javascript mailbox"
            <| let
                head =
                  { hash = "uno", d = 1, next = [ "duo" ], f = [] }

                action =
                  (ActionForPublish <| PublishHead head)

                account =
                  setup data action
               in
                expectSignal ( account.jsSignal, account.task ) toBe (ActionForPublish <| PublishHead head)
        , signalIt "dispatches publish action for the next tweets"
            <| let
                head =
                  { hash = "uno", d = 1, next = [ "foo" ], f = [ ] }

                nextTweet =
                  { hash = "foo", d = 2, t = "something", next = [] }

                model =
                  { data | accounts = [ { userAccount | head = head, tweets = [ nextTweet ] } ] }

                action =
                  (ActionForPublish <| PublishHead head)

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishTweet { headHash = "uno", tweet = nextTweet }) ]
        , signalIt "dispatches publish action for the next followBlocks"
            <| let
                head =
                  { hash = "uno", d = 1, next = [], f = [ "foo" ] }

                nextFollowBlock =
                  { hash = "foo", l = [ "somebody" ], next = [] }

                model =
                  { data | accounts = [ { userAccount | head = head, followBlocks = [ nextFollowBlock ] } ] }

                action =
                  (ActionForPublish <| PublishHead head)

                account =
                  setup model action
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
                  setup data action
               in
                expectSignal ( account.jsSignal, account.task ) toBe action
        , signalIt "dispatches publish action for the next item"
            <| let
                tweet =
                  { hash = "foo", d = 1, t = "something", next = [ "bar" ] }

                nextTweet =
                  { hash = "bar", d = 2, t = "something else", next = [] }

                model =
                  { data | accounts = [ { userAccount | tweets = [ tweet, nextTweet ] } ] }

                action =
                  (ActionForPublish <| PublishTweet { headHash = "user", tweet = tweet })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishTweet { headHash = "user", tweet = nextTweet }) ]
        ]
    , signalDescribe
        "FollowBlock Publish"
        [ signalIt "forwards publish followBlocks actions to javascript mailbox"
            <| let
                followBlock =
                  { hash = "foo", l = ["bar"], next = [] }

                action =
                  (ActionForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup data action
               in
                expectSignal ( account.jsSignal, account.task ) toBe action
        , signalIt "dispatches publish action for the next item"
            <| let
                followBlock =
                  { hash = "foo", l = ["uno"], next = [ "bar" ] }

                nextFollowBlock =
                  { hash = "bar", l = ["duo"], next = [] }

                model =
                  { data | accounts = [ { userAccount | followBlocks = [ followBlock, nextFollowBlock ] } ] }

                action =
                  (ActionForPublish <| PublishFollowBlock { headHash = "user", followBlock = followBlock })

                account =
                  setup model action
               in
                expectSignal ( account.actionsSignal, account.task ) toBe [ (ActionForPublish <| PublishFollowBlock { headHash = "user", followBlock = nextFollowBlock }) ]
        ]
    ]
