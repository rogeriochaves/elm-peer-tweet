module Publish.Update (update) where

import Msg as RootMsg exposing (..)
import Publish.Msg as Publish exposing (..)
import Publish.Model exposing (Model)


update : RootMsg.Msg -> Model -> Model
update msg model =
  case msg of
    MsgForPublish syncMsg ->
      updatePublish syncMsg model

    _ ->
      model


updatePublish : Publish.Msg -> Model -> Model
updatePublish msg model =
  case msg of
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
