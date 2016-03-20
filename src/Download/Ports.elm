module Download.Ports (..) where

import Account.Model as Account exposing (Hash, Head, Tweet, HeadHash, TweetHash)
import Action as RootAction exposing (..)
import Download.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)
import Download.Action exposing (..)
import Time exposing (every, second)
import Account.Action exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


type alias Error =
  ( Hash, String )


requestDownload : Signal RootAction.Action
requestDownload =
  (every <| 30 * second)
    |> Signal.map (always <| ActionForDownload BeginDownload)


port downloadHeadStream : Signal (Maybe Head)
port downloadErrorStream : Signal (Maybe Error)
port requestDownloadHead : Signal (Maybe HeadHash)
port requestDownloadHead =
  let
    getRequest action =
      case action of
        ActionForDownload (DownloadHead hash) ->
          Just hash

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


downloadErrorInput : Signal RootAction.Action
downloadErrorInput =
  let
    action ( hash, errorMessage ) =
      ActionForDownload <| ErrorDownload hash errorMessage
  in
    Signal.map
      (Maybe.map action >> Maybe.withDefault NoOp)
      downloadErrorStream


downloadHeadInput : Signal RootAction.Action
downloadHeadInput =
  Signal.map
    (Maybe.map (ActionForDownload << DoneDownloadHead) >> Maybe.withDefault NoOp)
    downloadHeadStream


port downloadTweetStream : Signal (Maybe TweetData)
port requestDownloadTweet : Signal (Maybe TweetIdentifier)
port requestDownloadTweet =
  let
    getRequest action =
      case action of
        ActionForDownload (DownloadTweet payload) ->
          Just payload

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


downloadTweetInput : Signal RootAction.Action
downloadTweetInput =
  Signal.map
    (Maybe.map (ActionForDownload << DoneDownloadTweet) >> Maybe.withDefault NoOp)
    downloadTweetStream


port downloadFollowBlockStream : Signal (Maybe FollowBlockData)
port requestDownloadFollowBlock : Signal (Maybe FollowBlockIdentifier)
port requestDownloadFollowBlock =
  let
    getRequest action =
      case action of
        ActionForDownload (DownloadFollowBlock payload) ->
          Just payload

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


downloadFollowBlockInput : Signal RootAction.Action
downloadFollowBlockInput =
  Signal.map
    (Maybe.map (ActionForDownload << DoneDownloadFollowBlock) >> Maybe.withDefault NoOp)
    downloadFollowBlockStream
