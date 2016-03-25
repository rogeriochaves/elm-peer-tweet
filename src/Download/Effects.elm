module Download.Effects (effects, initialEffects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Account.Model as Account
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (Hash, HeadHash, nextHash, nextHashToDownload)
import Maybe exposing (andThen)
import Accounts.Model as Accounts exposing (findAccount, getUserAccount, followingAccounts)
import Authentication.Model as Authentication


effects : Signal.Address RootAction.Action -> RootAction.Action -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Effects RootAction.Action
effects jsAddress action model =
  case action of
    ActionForDownload syncAction ->
      effectsDownload jsAddress syncAction model

    _ ->
      Effects.none


effectsDownload : Signal.Address RootAction.Action -> Download.Action -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Effects RootAction.Action
effectsDownload jsAddress action model =
  case action of
    BeginDownload ->
      let
        action =
          Effects.task << Task.succeed << ActionForDownload << DownloadHead << .hash << .head
      in
        case getUserAccount model of
          Just userAccount ->
            userAccount :: (followingAccounts model.accounts userAccount)
              |> List.map action
              |> Effects.batch

          Nothing ->
            Effects.none

    DownloadHead hash ->
      Signal.send jsAddress (ActionForDownload <| DownloadHead hash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadHead head ->
      Effects.batch
        [ Task.succeed (nextDownloadTweetAction head.hash model.accounts <| nextHash (Just head))
            |> Effects.task
        , downloadFirstFollowBlockEffect head
        ]

    DownloadTweet { headHash, tweetHash } ->
      Signal.send jsAddress (nextDownloadTweetAction headHash model.accounts <| Just tweetHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadTweet { headHash, tweet } ->
      Task.succeed (nextDownloadTweetAction headHash model.accounts <| nextHash (Just tweet))
        |> Effects.task

    DownloadFollowBlock { headHash, followBlockHash } ->
      Signal.send jsAddress (nextDownloadFollowBlockAction headHash model.accounts <| Just followBlockHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadFollowBlock { headHash, followBlock } ->
      Effects.batch
        [ Task.succeed (nextDownloadFollowBlockAction headHash model.accounts <| nextHash (Just followBlock))
            |> Effects.task
        , if (Just headHash) == model.authentication.hash then
            downloadFollowerEffect followBlock
          else
            Effects.none
        ]

    ErrorDownload _ _ ->
      Effects.none


initialEffects : Authentication.Model -> Effects RootAction.Action
initialEffects accounts =
  case accounts.hash of
    Just hash ->
      Task.succeed (ActionForDownload <| DownloadHead hash)
        |> Effects.task

    Nothing ->
      Effects.none


nextDownloadAction : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> (Hash -> RootAction.Action) -> HeadHash -> Accounts.Model -> Maybe Hash -> RootAction.Action
nextDownloadAction nextListKey actionFn headHash accounts followBlockHash =
  let
    nextItem =
      findAccount accounts (Just headHash)
        |> Maybe.map (\account -> followBlockHash `andThen` nextHashToDownload (nextListKey account))
        |> Maybe.withDefault followBlockHash
  in
    nextItem
      |> Maybe.map actionFn
      |> Maybe.withDefault NoOp


nextDownloadTweetAction : HeadHash -> Accounts.Model -> Maybe Hash -> RootAction.Action
nextDownloadTweetAction headHash =
  nextDownloadAction
    .tweets
    (\hash -> ActionForDownload <| DownloadTweet { headHash = headHash, tweetHash = hash })
    headHash


nextDownloadFollowBlockAction : HeadHash -> Accounts.Model -> Maybe Hash -> RootAction.Action
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
