module Download.Update (update, effects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Data.Model as Data
import Download.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Data.Model exposing (Hash, nextHash, findTweet)

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForDownload syncAction -> updateDownload syncAction model
    _ -> model

updateDownload : Download.Action -> Model -> Model
updateDownload action model =
  case action of
    BeginDownload -> model
    DownloadHead _ -> incDownloadingCount model
    DoneDownloadHead _ -> decDownloadingCount model
    DownloadTweet _ -> incDownloadingCount model
    DoneDownloadTweet _ -> decDownloadingCount model

incDownloadingCount : Model -> Model
incDownloadingCount model =
  { model | downloadingCount = model.downloadingCount + 1 }

decDownloadingCount : Model -> Model
decDownloadingCount model =
  { model | downloadingCount = model.downloadingCount - 1 }

effects : Signal.Address RootAction.Action -> RootAction.Action -> Data.Model -> Effects RootAction.Action
effects jsAddress action data =
  case action of
    ActionForDownload syncAction -> effectsDownload jsAddress syncAction data
    _ -> Effects.none

effectsDownload : Signal.Address RootAction.Action -> Download.Action -> Data.Model -> Effects RootAction.Action
effectsDownload jsAddress action data =
  case action of
    BeginDownload ->
      Task.succeed (ActionForDownload <| DownloadHead data.head.hash)
        |> Effects.task
    DownloadHead hash ->
      Signal.send jsAddress (ActionForDownload <| DownloadHead hash)
        |> Task.toMaybe
        |> Task.map (\_ -> NoOp)
        |> Effects.task
    DoneDownloadHead head ->
      Task.succeed (nextHash head |> nextDownloadAction)
        |> Effects.task
    DownloadTweet hash ->
      Signal.send jsAddress (ActionForDownload <| DownloadTweet hash)
        |> Task.toMaybe
        |> Task.map (\_ -> NoOp)
        |> Effects.task
    DoneDownloadTweet tweet ->
      Task.succeed (nextHash tweet |> nextDownloadAction)
        |> Effects.task

nextDownloadAction : Maybe Data.Hash -> RootAction.Action
nextDownloadAction hash =
  case hash of
    Just hash ->
      ActionForDownload (DownloadTweet hash)
    Nothing ->
      NoOp
