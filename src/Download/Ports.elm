module Download.Ports (..) where

import Account.Model as Account exposing (Head, Tweet, HeadHash, TweetHash)
import Action as RootAction exposing (..)
import Download.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)
import Download.Action exposing (..)
import Time exposing (every, second)


requestDownload : Signal RootAction.Action
requestDownload =
  (every <| 30 * second)
    |> Signal.map (always <| ActionForDownload BeginDownload)


port downloadHeadStream : Signal (Maybe Head)


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


downloadHeadInput : Signal RootAction.Action
downloadHeadInput =
  Signal.map (Maybe.map (ActionForDownload << DoneDownloadHead) >> Maybe.withDefault NoOp) downloadHeadStream


port downloadTweetStream : Signal (Maybe DoneDownloadTweetPayload)


port requestDownloadTweet : Signal (Maybe DownloadTweetPayload)
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


port downloadFollowBlockStream : Signal (Maybe DoneDownloadFollowBlockPayload)


port requestDownloadFollowBlock : Signal (Maybe DownloadFollowBlockPayload)
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
