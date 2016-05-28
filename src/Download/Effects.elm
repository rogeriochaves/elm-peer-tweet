module Download.Effects exposing (effects, initialEffects)

import Msg as RootMsg exposing (..)
import Download.Msg as Download exposing (..)
import Account.Model as Account
import Effects exposing (Effects)
import Task exposing (Task)
import Account.Model exposing (Hash, HeadHash, nextHash, nextHashToDownload)
import Maybe exposing (andThen)
import Accounts.Model as Accounts exposing (findAccount, getUserAccount, followingAccounts)
import Authentication.Model as Authentication


effects : Signal.Address RootMsg.Msg -> RootMsg.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Effects RootMsg.Msg
effects jsAddress msg model =
  case msg of
    MsgForDownload syncMsg ->
      effectsDownload jsAddress syncMsg model

    _ ->
      Effects.none


effectsDownload : Signal.Address RootMsg.Msg -> Download.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Effects RootMsg.Msg
effectsDownload jsAddress msg model =
  case msg of
    BeginDownload ->
      let
        msg =
          Effects.task << Task.succeed << MsgForDownload << DownloadHead << .hash << .head
      in
        case getUserAccount model of
          Just userAccount ->
            userAccount :: (followingAccounts model.accounts userAccount)
              |> List.map msg
              |> Effects.batch

          Nothing ->
            Effects.none

    DownloadHead hash ->
      Signal.send jsAddress (MsgForDownload <| DownloadHead hash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadHead head ->
      Effects.batch
        [ Task.succeed (nextDownloadTweetMsg head.hash model.accounts <| nextHash (Just head))
            |> Effects.task
        , downloadFirstFollowBlockEffect head
        ]

    DownloadTweet { headHash, tweetHash } ->
      Signal.send jsAddress (nextDownloadTweetMsg headHash model.accounts <| Just tweetHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadTweet { headHash, tweet } ->
      Task.succeed (nextDownloadTweetMsg headHash model.accounts <| nextHash (Just tweet))
        |> Effects.task

    DownloadFollowBlock { headHash, followBlockHash } ->
      Signal.send jsAddress (nextDownloadFollowBlockMsg headHash model.accounts <| Just followBlockHash)
        |> Task.map (always NoOp)
        |> Effects.task

    DoneDownloadFollowBlock { headHash, followBlock } ->
      Effects.batch
        [ Task.succeed (nextDownloadFollowBlockMsg headHash model.accounts <| nextHash (Just followBlock))
            |> Effects.task
        , if (Just headHash) == model.authentication.hash then
            downloadFollowerEffect followBlock
          else
            Effects.none
        ]

    ErrorDownload _ _ ->
      Effects.none


initialEffects : Authentication.Model -> Effects RootMsg.Msg
initialEffects accounts =
  case accounts.hash of
    Just hash ->
      Task.succeed (MsgForDownload <| DownloadHead hash)
        |> Effects.task

    Nothing ->
      Effects.none


nextDownloadMsg : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> (Hash -> RootMsg.Msg) -> HeadHash -> Accounts.Model -> Maybe Hash -> RootMsg.Msg
nextDownloadMsg nextListKey msgFn headHash accounts followBlockHash =
  let
    nextItem =
      findAccount accounts (Just headHash)
        |> Maybe.map (\account -> followBlockHash `andThen` nextHashToDownload (nextListKey account))
        |> Maybe.withDefault followBlockHash
  in
    nextItem
      |> Maybe.map msgFn
      |> Maybe.withDefault NoOp


nextDownloadTweetMsg : HeadHash -> Accounts.Model -> Maybe Hash -> RootMsg.Msg
nextDownloadTweetMsg headHash =
  nextDownloadMsg
    .tweets
    (\hash -> MsgForDownload <| DownloadTweet { headHash = headHash, tweetHash = hash })
    headHash


nextDownloadFollowBlockMsg : HeadHash -> Accounts.Model -> Maybe Hash -> RootMsg.Msg
nextDownloadFollowBlockMsg headHash =
  nextDownloadMsg
    .followBlocks
    (\hash -> MsgForDownload <| DownloadFollowBlock { headHash = headHash, followBlockHash = hash })
    headHash


downloadFirstFollowBlockEffect : Account.Head -> Effects RootMsg.Msg
downloadFirstFollowBlockEffect head =
  let
    foundFollowBlockHash =
      List.head head.f
  in
    case foundFollowBlockHash of
      Just followBlockHash ->
        Task.succeed (MsgForDownload (DownloadFollowBlock { headHash = head.hash, followBlockHash = followBlockHash }))
          |> Effects.task

      Nothing ->
        Effects.none


downloadFollowerEffect : Account.FollowBlock -> Effects RootMsg.Msg
downloadFollowerEffect followBlock =
  followBlock.l
    |> List.map (Effects.task << Task.succeed << MsgForDownload << DownloadHead)
    |> Effects.batch
