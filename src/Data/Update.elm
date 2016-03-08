module Data.Update (update, effects) where

import Action as RootAction exposing (..)
import Data.Action exposing (..)
import Download.Action as DownloadAction exposing (..)
import Data.Model exposing (Model, addTweet)
import Effects exposing (Effects)
import Task exposing (Task)

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForData (UpdateData data) ->
      data
    ActionForDownload downloadAction ->
      updateDownloadedData downloadAction model
    _ ->
      model

updateDownloadedData : DownloadAction.Action -> Model -> Model
updateDownloadedData action model =
  case action of
    DoneDownloadHead head ->
      { model | head = head }
    DoneDownloadTweet tweet ->
      addTweet model tweet
    _ -> model

effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForData (AddTweetRequest request) ->
      Signal.send jsAddress (ActionForData (AddTweetRequest request))
        |> Task.toMaybe
        |> Task.map (always NoOp)
        |> Effects.task
    _ ->
      Effects.none
