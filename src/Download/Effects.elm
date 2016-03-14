module Download.Effects (effects) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Account.Model as Account
import Data.Model as Data
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (Hash, HeadHash, nextHash, nextHashToDownload)
import Maybe exposing (andThen)
import Data.Model as Data exposing (findAccount)


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
      Effects.batch
        [ Task.succeed (nextDownloadFollowBlockAction headHash data <| nextHash (Just followBlock))
            |> Effects.task
        , if headHash == data.hash then
            downloadFollowerEffect followBlock
          else
            Effects.none
        ]


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
