module Download.Effects (effects, initialEffects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Account.Model as Account
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (Hash, HeadHash, nextHash, nextHashToDownload)
import Maybe exposing (andThen)
import Data.Model as Data exposing (findAccount, getUserAccount)
import Authentication.Model as Authentication


effects : Signal.Address RootAction.Action -> RootAction.Action -> { a | data : Data.Model, authentication : Authentication.Model } -> Effects RootAction.Action
effects jsAddress action model =
  case action of
    ActionForDownload syncAction ->
      effectsDownload jsAddress syncAction model

    _ ->
      Effects.none


effectsDownload : Signal.Address RootAction.Action -> Download.Action -> { a | data : Data.Model, authentication : Authentication.Model } -> Effects RootAction.Action
effectsDownload jsAddress action model =
  case action of
    BeginDownload ->
      let
        action =
          model.authentication.hash
            |> Maybe.map (\hash -> Effects.task <| Task.succeed (ActionForDownload <| DownloadHead hash))
            |> Maybe.withDefault Effects.none
      in
        getUserAccount model
          |> Maybe.map (always action)
          |> Maybe.withDefault Effects.none

    DownloadHead hash ->
      Signal.send jsAddress (ActionForDownload <| DownloadHead hash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadHead head ->
      Effects.batch
        [ Task.succeed (nextDownloadTweetAction head.hash model.data <| nextHash (Just head))
            |> Effects.task
        , downloadFirstFollowBlockEffect head
        ]

    DownloadTweet { headHash, tweetHash } ->
      Signal.send jsAddress (nextDownloadTweetAction headHash model.data <| Just tweetHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadTweet { headHash, tweet } ->
      Task.succeed (nextDownloadTweetAction headHash model.data <| nextHash (Just tweet))
        |> Effects.task

    DownloadFollowBlock { headHash, followBlockHash } ->
      Signal.send jsAddress (nextDownloadFollowBlockAction headHash model.data <| Just followBlockHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadFollowBlock { headHash, followBlock } ->
      Effects.batch
        [ Task.succeed (nextDownloadFollowBlockAction headHash model.data <| nextHash (Just followBlock))
            |> Effects.task
        , if (Just headHash) == model.authentication.hash then
            downloadFollowerEffect followBlock
          else
            Effects.none
        ]

    ErrorDownload _ _ ->
      Effects.none


initialEffects : Authentication.Model -> Effects RootAction.Action
initialEffects data =
  case data.hash of
    Just hash ->
      Task.succeed (ActionForDownload <| DownloadHead hash)
        |> Effects.task

    Nothing ->
      Effects.none


nextDownloadAction : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> (Hash -> RootAction.Action) -> HeadHash -> Data.Model -> Maybe Hash -> RootAction.Action
nextDownloadAction nextListKey actionFn headHash data followBlockHash =
  let
    nextItem =
      findAccount data (Just headHash)
        |> Maybe.map (\account -> followBlockHash `andThen` nextHashToDownload (nextListKey account))
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


downloadFollowerEffect : Account.FollowBlock -> Effects RootAction.Action
downloadFollowerEffect followBlock =
  followBlock.l
    |> List.map (Effects.task << Task.succeed << ActionForDownload << DownloadHead)
    |> Effects.batch
