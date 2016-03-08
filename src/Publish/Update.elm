module Publish.Update (update, effects) where

import Action as RootAction exposing (..)
import Publish.Action as Publish exposing (..)
import Data.Model as Data
import Publish.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Data.Model exposing (Hash, nextHash, findTweet)

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForPublish syncAction -> updatePublish syncAction model
    _ -> model

updatePublish : Publish.Action -> Model -> Model
updatePublish action model =
  case action of
    BeginPublish -> model
    PublishHead _ -> incPublishingCount model
    DonePublishHead _ -> decPublishingCount model
    PublishTweet _ -> incPublishingCount model
    DonePublishTweet _ -> decPublishingCount model

incPublishingCount : Model -> Model
incPublishingCount model =
  { model | publishingCount = model.publishingCount + 1 }

decPublishingCount : Model -> Model
decPublishingCount model =
  { model | publishingCount = model.publishingCount - 1 }

effects : Signal.Address RootAction.Action -> RootAction.Action -> Data.Model -> Effects RootAction.Action
effects jsAddress action data =
  case action of
    ActionForPublish syncAction -> effectsPublish jsAddress syncAction data |> Effects.task
    _ -> Effects.none

effectsPublish : Signal.Address RootAction.Action -> Publish.Action -> Data.Model -> Task a RootAction.Action
effectsPublish jsAddress action data =
  case action of
    BeginPublish ->
      Task.succeed (ActionForPublish <| PublishHead data.head)
    PublishHead head ->
      Signal.send jsAddress (ActionForPublish <| PublishHead head)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishAction <| findTweet data <| nextHash <| Just head)
    DonePublishHead _ ->
      Task.succeed NoOp
    PublishTweet tweet ->
      Signal.send jsAddress (ActionForPublish <| PublishTweet tweet)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishAction <| findTweet data <| nextHash <| Just tweet)
    DonePublishTweet _ ->
      Task.succeed NoOp

nextPublishAction : Maybe Data.Tweet -> RootAction.Action
nextPublishAction tweet =
  case tweet of
    Just tweet ->
      ActionForPublish (PublishTweet tweet)
    Nothing ->
      NoOp
