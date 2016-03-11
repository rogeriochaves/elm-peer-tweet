module Publish.Update (update, effects) where

import Action as RootAction exposing (..)
import Publish.Action as Publish exposing (..)
import Account.Model as Account
import Publish.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (Hash, nextHash, findTweet)


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


effects : Signal.Address RootAction.Action -> RootAction.Action -> Account.Model -> Effects RootAction.Action
effects jsAddress action account =
  case action of
    ActionForPublish syncAction ->
      effectsPublish jsAddress syncAction account |> Effects.task

    _ ->
      Effects.none


effectsPublish : Signal.Address RootAction.Action -> Publish.Action -> Account.Model -> Task a RootAction.Action
effectsPublish jsAddress action account =
  case action of
    BeginPublish ->
      Task.succeed (ActionForPublish <| PublishHead account.head)

    PublishHead head ->
      Signal.send jsAddress (ActionForPublish <| PublishHead head)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishAction <| findTweet account <| nextHash <| Just head)

    DonePublishHead _ ->
      Task.succeed NoOp

    PublishTweet tweet ->
      Signal.send jsAddress (ActionForPublish <| PublishTweet tweet)
        |> Task.toMaybe
        |> Task.map (always <| nextPublishAction <| findTweet account <| nextHash <| Just tweet)

    DonePublishTweet _ ->
      Task.succeed NoOp


nextPublishAction : Maybe Account.Tweet -> RootAction.Action
nextPublishAction tweet =
  case tweet of
    Just tweet ->
      ActionForPublish (PublishTweet tweet)

    Nothing ->
      NoOp
