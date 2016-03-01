module Sync.Update (update, effects) where

import Action as RootAction exposing (..)
import Sync.Action as Sync exposing (..)
import Data.Model as Data
import Sync.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Data.Model exposing (Hash, nextHash, findTweet)

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForSync syncAction -> updateSync syncAction model
    _ -> model

updateSync : Sync.Action -> Model -> Model
updateSync action model =
  case action of
    BeginSync -> model
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
    ActionForSync syncAction -> effectsSync jsAddress syncAction data
    _ -> Effects.none

effectsSync : Signal.Address RootAction.Action -> Sync.Action -> Data.Model -> Effects RootAction.Action
effectsSync jsAddress action data =
  case action of
    BeginSync ->
      Task.succeed (ActionForSync <| PublishHead data.head)
        |> Effects.task
    PublishHead head ->
      Signal.send jsAddress (ActionForSync <| PublishHead head)
        |> Task.toMaybe
        |> Task.map (\_ -> nextHash head |> findTweet data |> nextPublishAction)
        |> Effects.task
    DonePublishHead _ ->
      Effects.none
    PublishTweet tweet ->
      Signal.send jsAddress (ActionForSync <| PublishTweet tweet)
        |> Task.toMaybe
        |> Task.map (\_ -> nextHash tweet |> findTweet data |> nextPublishAction)
        |> Effects.task
    DonePublishTweet _ ->
      Effects.none

nextPublishAction : Maybe Data.Tweet -> RootAction.Action
nextPublishAction tweet =
  case tweet of
    Just tweet ->
      ActionForSync (PublishTweet tweet)
    Nothing ->
      NoOp
