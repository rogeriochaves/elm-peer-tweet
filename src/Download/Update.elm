module Download.Update (update, effects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Account.Model as Account
import Data.Model as Data
import Download.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (HeadHash, TweetHash, nextHash, nextHashToDownload, findTweet)
import Maybe exposing (andThen)
import Data.Model as Data exposing (findAccount)


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
effects jsAddress action account =
  case action of
    ActionForDownload syncAction ->
      effectsDownload jsAddress syncAction account |> Effects.task

    _ ->
      Effects.none


effectsDownload : Signal.Address RootAction.Action -> Download.Action -> Data.Model -> Task a RootAction.Action
effectsDownload jsAddress action data =
  case action of
    BeginDownload ->
      Task.succeed (ActionForDownload <| DownloadHead data.hash)

    DownloadHead hash ->
      Signal.send jsAddress (ActionForDownload <| DownloadHead hash)
        |> Task.toMaybe
        |> Task.map (always NoOp)

    DoneDownloadHead head ->
      Task.succeed (nextDownloadAction data head.hash <| nextHash (Just head))

    DownloadTweet { headHash, tweetHash } ->
      Signal.send jsAddress (nextDownloadAction data headHash <| Just tweetHash)
        |> Task.toMaybe
        |> Task.map (always NoOp)

    DoneDownloadTweet { headHash, tweet } ->
      Task.succeed (nextDownloadAction data headHash <| nextHash (Just tweet))


nextDownloadAction : Data.Model -> HeadHash -> Maybe TweetHash -> RootAction.Action
nextDownloadAction data headHash tweetHash =
  let
    foundAccount =
      findAccount data (Just headHash)
  in
    case foundAccount of
      Just account ->
        tweetHash
          `andThen` nextHashToDownload account
          |> Maybe.map (\hash -> ActionForDownload <| DownloadTweet { headHash = account.head.hash, tweetHash = hash })
          |> Maybe.withDefault NoOp

      Nothing ->
        tweetHash
          |> Maybe.map (\hash -> ActionForDownload <| DownloadTweet { headHash = headHash, tweetHash = hash })
          |> Maybe.withDefault NoOp
