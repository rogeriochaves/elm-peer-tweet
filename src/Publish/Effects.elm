module Publish.Effects (effects) where

import Action as RootAction exposing (..)
import Publish.Action as Publish exposing (..)
import Account.Model as Account
import Data.Model as Data exposing (getUserAccount, findAccount)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Hash, FollowBlock, nextHash, firstFollowBlock, findItem)
import Maybe exposing (andThen)
import Authentication.Model as Authentication


effects : Signal.Address RootAction.Action -> RootAction.Action -> { a | data : Data.Model, authentication : Authentication.Model } -> Effects RootAction.Action
effects jsAddress action model =
  case action of
    ActionForPublish syncAction ->
      effectsPublish jsAddress syncAction model

    _ ->
      Effects.none


effectsPublish : Signal.Address RootAction.Action -> Publish.Action -> { a | data : Data.Model, authentication : Authentication.Model } -> Effects RootAction.Action
effectsPublish jsAddress action model =
  case action of
    BeginPublish ->
      Task.succeed (Maybe.withDefault NoOp <| Maybe.map (ActionForPublish << PublishHead << .head) (getUserAccount model))
        |> Effects.task

    PublishHead head ->
      Effects.batch
        [ Signal.send jsAddress (ActionForPublish <| PublishHead head)
            |> Task.map (always <| nextPublishTweetAction head.hash model.data head)
            |> Effects.task
        , publishFirstFollowBlockEffect model.data head
        ]

    DonePublishHead _ ->
      Task.succeed NoOp
        |> Effects.task

    PublishTweet payload ->
      Signal.send jsAddress (ActionForPublish <| PublishTweet payload)
        |> Task.map (always <| nextPublishTweetAction payload.headHash model.data payload.tweet)
        |> Effects.task

    DonePublishTweet _ ->
      Task.succeed NoOp
        |> Effects.task

    PublishFollowBlock payload ->
      Effects.batch
        [ Signal.send jsAddress (ActionForPublish <| PublishFollowBlock payload)
            |> Task.map (always <| nextPublishFollowBlockAction payload.headHash model.data payload.followBlock)
            |> Effects.task
        , if (Just payload.headHash) == model.authentication.hash then
            publishFollowerEffect model.data payload.followBlock
          else
            Effects.none
        ]

    DonePublishFollowBlock _ ->
      Task.succeed NoOp
        |> Effects.task


publishFirstFollowBlockEffect : Data.Model -> Account.Head -> Effects RootAction.Action
publishFirstFollowBlockEffect data head =
  let
    foundFollowBlock =
      findAccount data (Just head.hash) `andThen` firstFollowBlock
  in
    case foundFollowBlock of
      Just followBlock ->
        Task.succeed (ActionForPublish (PublishFollowBlock { headHash = head.hash, followBlock = followBlock }))
          |> Effects.task

      Nothing ->
        Effects.none


nextItemAction : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> ({ a | hash : Hash, next : List Hash } -> RootAction.Action) -> HeadHash -> Data.Model -> { b | next : List Hash } -> RootAction.Action
nextItemAction listKey actionFn headHash data item =
  let
    hash =
      nextHash (Just item)

    foundItem =
      findAccount data (Just headHash) `andThen` (\account -> findItem (listKey account) hash)
  in
    foundItem
      |> Maybe.map actionFn
      |> Maybe.withDefault NoOp


nextPublishTweetAction : HeadHash -> Data.Model -> { a | next : List TweetHash } -> RootAction.Action
nextPublishTweetAction headHash =
  nextItemAction
    .tweets
    (\tweet -> ActionForPublish (PublishTweet { headHash = headHash, tweet = tweet }))
    headHash


nextPublishFollowBlockAction : HeadHash -> Data.Model -> { a | next : List FollowBlockHash } -> RootAction.Action
nextPublishFollowBlockAction headHash =
  nextItemAction
    .followBlocks
    (\followBlock -> ActionForPublish (PublishFollowBlock { headHash = headHash, followBlock = followBlock }))
    headHash


publishFollowerEffect : Data.Model -> Account.FollowBlock -> Effects RootAction.Action
publishFollowerEffect data followBlock =
  let
    effectMap hash =
      findAccount data (Just hash)
        |> Maybe.map (Effects.task << Task.succeed << ActionForPublish << PublishHead << .head)
        |> Maybe.withDefault Effects.none
  in
    followBlock.l
      |> List.map effectMap
      |> Effects.batch
