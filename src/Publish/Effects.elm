module Publish.Effects (effects) where

import Msg as RootMsg exposing (..)
import Publish.Msg as Publish exposing (..)
import Account.Model as Account
import Accounts.Model as Accounts exposing (getUserAccount, findAccount)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Hash, FollowBlock, nextHash, firstFollowBlock, findItem)
import Maybe exposing (andThen)
import Authentication.Model as Authentication


effects : Signal.Address RootMsg.Msg -> RootMsg.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Effects RootMsg.Msg
effects jsAddress msg model =
  case msg of
    MsgForPublish syncMsg ->
      effectsPublish jsAddress syncMsg model

    _ ->
      Effects.none


effectsPublish : Signal.Address RootMsg.Msg -> Publish.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Effects RootMsg.Msg
effectsPublish jsAddress msg model =
  case msg of
    BeginPublish ->
      Task.succeed (Maybe.withDefault NoOp <| Maybe.map (MsgForPublish << PublishHead << .head) (getUserAccount model))
        |> Effects.task

    PublishHead head ->
      Effects.batch
        [ Signal.send jsAddress (MsgForPublish <| PublishHead head)
            |> Task.map (always <| nextPublishTweetMsg head.hash model.accounts head)
            |> Effects.task
        , publishFirstFollowBlockEffect model.accounts head
        ]

    DonePublishHead _ ->
      Task.succeed NoOp
        |> Effects.task

    PublishTweet payload ->
      Signal.send jsAddress (MsgForPublish <| PublishTweet payload)
        |> Task.map (always <| nextPublishTweetMsg payload.headHash model.accounts payload.tweet)
        |> Effects.task

    DonePublishTweet _ ->
      Task.succeed NoOp
        |> Effects.task

    PublishFollowBlock payload ->
      Effects.batch
        [ Signal.send jsAddress (MsgForPublish <| PublishFollowBlock payload)
            |> Task.map (always <| nextPublishFollowBlockMsg payload.headHash model.accounts payload.followBlock)
            |> Effects.task
        , if (Just payload.headHash) == model.authentication.hash then
            publishFollowerEffect model.accounts payload.followBlock
          else
            Effects.none
        ]

    DonePublishFollowBlock _ ->
      Task.succeed NoOp
        |> Effects.task


publishFirstFollowBlockEffect : Accounts.Model -> Account.Head -> Effects RootMsg.Msg
publishFirstFollowBlockEffect accounts head =
  let
    foundFollowBlock =
      findAccount accounts (Just head.hash) `andThen` firstFollowBlock
  in
    case foundFollowBlock of
      Just followBlock ->
        Task.succeed (MsgForPublish (PublishFollowBlock { headHash = head.hash, followBlock = followBlock }))
          |> Effects.task

      Nothing ->
        Effects.none


nextItemMsg : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> ({ a | hash : Hash, next : List Hash } -> RootMsg.Msg) -> HeadHash -> Accounts.Model -> { b | next : List Hash } -> RootMsg.Msg
nextItemMsg listKey msgFn headHash accounts item =
  let
    hash =
      nextHash (Just item)

    foundItem =
      findAccount accounts (Just headHash) `andThen` (\account -> findItem (listKey account) hash)
  in
    foundItem
      |> Maybe.map msgFn
      |> Maybe.withDefault NoOp


nextPublishTweetMsg : HeadHash -> Accounts.Model -> { a | next : List TweetHash } -> RootMsg.Msg
nextPublishTweetMsg headHash =
  nextItemMsg
    .tweets
    (\tweet -> MsgForPublish (PublishTweet { headHash = headHash, tweet = tweet }))
    headHash


nextPublishFollowBlockMsg : HeadHash -> Accounts.Model -> { a | next : List FollowBlockHash } -> RootMsg.Msg
nextPublishFollowBlockMsg headHash =
  nextItemMsg
    .followBlocks
    (\followBlock -> MsgForPublish (PublishFollowBlock { headHash = headHash, followBlock = followBlock }))
    headHash


publishFollowerEffect : Accounts.Model -> Account.FollowBlock -> Effects RootMsg.Msg
publishFollowerEffect accounts followBlock =
  let
    effectMap hash =
      findAccount accounts (Just hash)
        |> Maybe.map (Effects.task << Task.succeed << MsgForPublish << PublishHead << .head)
        |> Maybe.withDefault Effects.none
  in
    followBlock.l
      |> List.map effectMap
      |> Effects.batch
