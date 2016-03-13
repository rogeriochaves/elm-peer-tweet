module Download.Update (update, effects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Account.Model as Account
import Data.Model as Data
import Download.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, nextHash, nextHashToDownload, nextFollowBlockHashToDownload, findTweet)
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

    DownloadFollowBlock _ ->
      incDownloadingCount model

    DoneDownloadFollowBlock _ ->
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
      effectsDownload jsAddress syncAction account

    _ ->
      Effects.none


effectsDownload : Signal.Address RootAction.Action -> Download.Action -> Data.Model -> Effects RootAction.Action
effectsDownload jsAddress action data =
  case action of
    BeginDownload ->
      Task.succeed (ActionForDownload <| DownloadHead data.hash)
        |> Effects.task

    DownloadHead hash ->
      Signal.send jsAddress (ActionForDownload <| DownloadHead hash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadHead head ->
      Effects.batch
        [ Task.succeed (nextDownloadTweetAction data head.hash <| nextHash (Just head))
            |> Effects.task
        , downloadFirstFollowBlockEffect head
        ]

    DownloadTweet { headHash, tweetHash } ->
      Signal.send jsAddress (nextDownloadTweetAction data headHash <| Just tweetHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadTweet { headHash, tweet } ->
      Task.succeed (nextDownloadTweetAction data headHash <| nextHash (Just tweet))
        |> Effects.task

    DownloadFollowBlock { headHash, followBlockHash } ->
      Signal.send jsAddress (nextDownloadFollowBlockAction data headHash <| Just followBlockHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadFollowBlock { headHash, followBlock } ->
      Task.succeed (nextDownloadFollowBlockAction data headHash <| nextHash (Just followBlock))
        |> Effects.task

downloadFirstFollowBlockEffect : Account.Head -> Effects RootAction.Action
downloadFirstFollowBlockEffect head =
  let
    foundFollowBlockHash =
      List.head head.f
  in
    case foundFollowBlockHash of
      Just followBlockHash ->
        Task.succeed (ActionForDownload (DownloadFollowBlock { headHash = head.hash, followBlockHash = followBlockHash }))
          |> Effects.task

      Nothing ->
        Effects.none


nextDownloadTweetAction : Data.Model -> HeadHash -> Maybe TweetHash -> RootAction.Action
nextDownloadTweetAction data headHash tweetHash =
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

nextDownloadFollowBlockAction : Data.Model -> HeadHash -> Maybe FollowBlockHash -> RootAction.Action
nextDownloadFollowBlockAction data headHash followBlockHash =
  let
    foundAccount =
      findAccount data (Just headHash)
  in
    case foundAccount of
      Just account ->
        followBlockHash
          `andThen` nextFollowBlockHashToDownload account
          |> Maybe.map (\hash -> ActionForDownload <| DownloadFollowBlock { headHash = account.head.hash, followBlockHash = hash })
          |> Maybe.withDefault NoOp

      Nothing ->
        followBlockHash
          |> Maybe.map (\hash -> ActionForDownload <| DownloadFollowBlock { headHash = headHash, followBlockHash = hash })
          |> Maybe.withDefault NoOp
