module Publish.Update (update) where

import Action as RootAction exposing (..)
import Publish.Action as Publish exposing (..)
import Publish.Model exposing (Model)


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
