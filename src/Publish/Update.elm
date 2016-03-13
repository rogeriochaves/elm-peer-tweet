module Publish.Update (update, effects) where

import Action as RootAction exposing (..)
import Publish.Action as Publish exposing (..)
import Account.Model as Account
import Data.Model as Data exposing (getUserAccount, findAccount)
import Publish.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Hash, FollowBlock, nextHash, findTweet, firstFollowBlock)
import Maybe exposing (andThen)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForPublish syncAction ->
      updatePublish syncAction model

    _ ->
      model


updatePublish : Publish.Action -> Model -> Model
updatePublish action model =
  case action of
    BeginPublish ->
      model

    PublishHead _ ->
      incPublishingCount model

    DonePublishHead _ ->
      decPublishingCount model

    PublishTweet _ ->
      incPublishingCount model

    DonePublishTweet _ ->
      decPublishingCount model

    PublishFollowBlock _ ->
      incPublishingCount model

    DonePublishFollowBlock _ ->
      decPublishingCount model


incPublishingCount : Model -> Model
incPublishingCount model =
  { model | publishingCount = model.publishingCount + 1 }


decPublishingCount : Model -> Model
decPublishingCount model =
  { model | publishingCount = model.publishingCount - 1 }


effects : Signal.Address RootAction.Action -> RootAction.Action -> Data.Model -> Effects RootAction.Action
effects jsAddress action data =
  case action of
    ActionForPublish syncAction ->
      effectsPublish jsAddress syncAction data

    _ ->
      Effects.none


effectsPublish : Signal.Address RootAction.Action -> Publish.Action -> Data.Model -> Effects RootAction.Action
effectsPublish jsAddress action data =
  case action of
    BeginPublish ->
      Task.succeed (Maybe.withDefault NoOp <| Maybe.map (ActionForPublish << PublishHead << .head) (getUserAccount data))
        |> Effects.task

    PublishHead head ->
      Effects.batch
        [ Signal.send jsAddress (ActionForPublish <| PublishHead head)
            |> Task.toMaybe
            |> Task.map (always <| nextPublishTweetAction data head.hash head)
            |> Effects.task
        , publishFirstFollowBlockEffect data head
        ]

    DonePublishHead _ ->
      Task.succeed NoOp
        |> Effects.task

    PublishTweet payload ->
      Signal.send jsAddress (ActionForPublish <| PublishTweet payload)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishTweetAction data payload.headHash payload.tweet)
        |> Effects.task

    DonePublishTweet _ ->
      Task.succeed NoOp
        |> Effects.task

    PublishFollowBlock payload ->
      Signal.send jsAddress (ActionForPublish <| PublishFollowBlock payload)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishTweetAction data payload.headHash payload.followBlock)
        |> Effects.task

    DonePublishFollowBlock _ ->
      Task.succeed NoOp
        |> Effects.task


nextPublishTweetAction : Data.Model -> HeadHash -> { a | next : List TweetHash } -> RootAction.Action
nextPublishTweetAction data headHash item =
  let
    hash =
      nextHash (Just item)

    foundTweet =
      findAccount data (Just headHash) `andThen` (\x -> findTweet x hash)
  in
    case foundTweet of
      Just tweet ->
        ActionForPublish (PublishTweet { headHash = headHash, tweet = tweet })

      Nothing ->
        NoOp


publishFirstFollowBlockEffect : Data.Model -> Account.Head -> Effects RootAction.Action
publishFirstFollowBlockEffect data head =
  let
    account =
      findAccount data (Just head.hash)

    foundFollowBlock =
      account `andThen` firstFollowBlock
  in
    case foundFollowBlock of
      Just followBlock ->
        Task.succeed (ActionForPublish (PublishFollowBlock { headHash = head.hash, followBlock = followBlock }))
          |> Effects.task

      Nothing ->
        Effects.none
