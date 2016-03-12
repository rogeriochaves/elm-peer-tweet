module Publish.Update (update, effects) where

import Action as RootAction exposing (..)
import Publish.Action as Publish exposing (..)
import Account.Model as Account
import Data.Model as Data exposing (getUserAccount, findAccount)
import Publish.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (HeadHash, Hash, nextHash, findTweet)
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
      effectsPublish jsAddress syncAction data |> Effects.task

    _ ->
      Effects.none


effectsPublish : Signal.Address RootAction.Action -> Publish.Action -> Data.Model -> Task a RootAction.Action
effectsPublish jsAddress action data =
  case action of
    BeginPublish ->
      Task.succeed (Maybe.withDefault NoOp <| Maybe.map (ActionForPublish << PublishHead << .head) (getUserAccount data))

    PublishHead head ->
      Signal.send jsAddress (ActionForPublish <| PublishHead head)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishAction data head.hash head)

    DonePublishHead _ ->
      Task.succeed NoOp

    PublishTweet payload ->
      Signal.send jsAddress (ActionForPublish <| PublishTweet payload)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishAction data payload.headHash payload.tweet)

    DonePublishTweet _ ->
      Task.succeed NoOp


nextPublishAction : Data.Model -> HeadHash -> { a | next : List Hash } -> RootAction.Action
nextPublishAction data headHash item =
  let
    hash =
      nextHash (Just item)

    tweet =
      findAccount data (Just headHash) `andThen` (\x -> findTweet x hash)
  in
    case tweet of
      Just tweet ->
        ActionForPublish (PublishTweet { headHash = headHash, tweet = tweet })

      Nothing ->
        NoOp
