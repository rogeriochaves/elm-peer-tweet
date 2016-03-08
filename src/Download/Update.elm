module Download.Update (update, effects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Data.Model as Data
import Download.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Data.Model exposing (Hash, nextHash, nextHashToDownload, findTweet)
import Maybe exposing (andThen)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForDownload syncAction ->
      updateDownload syncAction model

    _ ->
      model


updateDownload : Download.Action -> Model -> Model
updateDownload action model =
  case action of
    BeginDownload ->
      model

    DownloadHead _ ->
      incDownloadingCount model

    DoneDownloadHead _ ->
      decDownloadingCount model

    DownloadTweet _ ->
      incDownloadingCount model

    DoneDownloadTweet _ ->
      decDownloadingCount model


incDownloadingCount : Model -> Model
incDownloadingCount model =
  { model | downloadingCount = model.downloadingCount + 1 }


decDownloadingCount : Model -> Model
decDownloadingCount model =
  { model | downloadingCount = model.downloadingCount - 1 }


effects : Signal.Address RootAction.Action -> RootAction.Action -> Data.Model -> Effects RootAction.Action
effects jsAddress action data =
  case action of
    ActionForDownload syncAction ->
      effectsDownload jsAddress syncAction data |> Effects.task

    _ ->
      Effects.none


effectsDownload : Signal.Address RootAction.Action -> Download.Action -> Data.Model -> Task a RootAction.Action
effectsDownload jsAddress action data =
  case action of
    BeginDownload ->
      Task.succeed (ActionForDownload <| DownloadHead data.head.hash)

    DownloadHead hash ->
      Signal.send jsAddress (ActionForDownload <| DownloadHead hash)
        |> Task.toMaybe
        |> Task.map (always NoOp)

    DoneDownloadHead head ->
      Task.succeed (nextDownloadAction data <| nextHash (Just head))

    DownloadTweet hash ->
      Signal.send jsAddress (nextDownloadAction data <| Just hash)
        |> Task.toMaybe
        |> Task.map (always NoOp)

    DoneDownloadTweet tweet ->
      Task.succeed (nextDownloadAction data <| nextHash (Just tweet))


nextDownloadAction : Data.Model -> Maybe Hash -> RootAction.Action
nextDownloadAction data hash =
  hash
    `andThen` nextHashToDownload data
    |> Maybe.map (ActionForDownload << DownloadTweet)
    |> Maybe.withDefault NoOp
