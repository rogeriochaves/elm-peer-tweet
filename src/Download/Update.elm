module Download.Update (update, effects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Account.Model as Account
import Data.Model as Data
import Download.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (Hash, HeadHash, TweetHash, FollowBlockHash, nextHash, nextHashToDownload, nextItemToDownload, findTweet)
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
        [ Task.succeed (nextDownloadTweetAction head.hash data <| nextHash (Just head))
            |> Effects.task
        , downloadFirstFollowBlockEffect head
        ]

    DownloadTweet { headHash, tweetHash } ->
      Signal.send jsAddress (nextDownloadTweetAction headHash data <| Just tweetHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadTweet { headHash, tweet } ->
      Task.succeed (nextDownloadTweetAction headHash data <| nextHash (Just tweet))
        |> Effects.task

    DownloadFollowBlock { headHash, followBlockHash } ->
      Signal.send jsAddress (nextDownloadFollowBlockAction headHash data <| Just followBlockHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadFollowBlock { headHash, followBlock } ->
      Task.succeed (nextDownloadFollowBlockAction headHash data <| nextHash (Just followBlock))
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


nextDownloadAction : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> (Hash -> RootAction.Action) -> HeadHash -> Data.Model -> Maybe Hash -> RootAction.Action
nextDownloadAction nextListKey actionFn headHash data followBlockHash =
  let
    nextItem =
      findAccount data (Just headHash)
        |> Maybe.map (\account -> followBlockHash `andThen` nextItemToDownload (nextListKey account))
        |> Maybe.withDefault followBlockHash
  in
    nextItem
      |> Maybe.map actionFn
      |> Maybe.withDefault NoOp


nextDownloadTweetAction : HeadHash -> Data.Model -> Maybe Hash -> RootAction.Action
nextDownloadTweetAction headHash =
  nextDownloadAction
    .tweets
    (\hash -> ActionForDownload <| DownloadTweet { headHash = headHash, tweetHash = hash })
    headHash


nextDownloadFollowBlockAction : HeadHash -> Data.Model -> Maybe Hash -> RootAction.Action
nextDownloadFollowBlockAction headHash =
  nextDownloadAction
    .followBlocks
    (\hash -> ActionForDownload <| DownloadFollowBlock { headHash = headHash, followBlockHash = hash })
    headHash
