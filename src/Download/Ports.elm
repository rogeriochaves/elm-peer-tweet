module Download.Ports (..) where

import Account.Model as Account exposing (Hash, Head, Tweet, HeadHash, TweetHash)
import Msg as RootMsg exposing (..)
import Download.Msg exposing (..)
import Ports exposing (jsMailbox)
import Utils.Utils exposing (isJust, filterEmpty)
import Download.Msg exposing (..)
import Time exposing (every, second)
import Account.Msg exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


type alias Error =
  ( Hash, String )


requestDownload : Signal RootMsg.Msg
requestDownload =
  (every <| 30 * second)
    |> Signal.map (always <| MsgForDownload BeginDownload)


port downloadHeadStream : Signal (Maybe Head)
port downloadErrorStream : Signal (Maybe Error)
port requestDownloadHead : Signal (Maybe HeadHash)
port requestDownloadHead =
  let
    getRequest msg =
      case msg of
        MsgForDownload (DownloadHead hash) ->
          Just hash

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


downloadErrorInput : Signal RootMsg.Msg
downloadErrorInput =
  let
    msg ( hash, errorMessage ) =
      MsgForDownload <| ErrorDownload hash errorMessage
  in
    Signal.map
      (Maybe.map msg >> Maybe.withDefault NoOp)
      downloadErrorStream


downloadHeadInput : Signal RootMsg.Msg
downloadHeadInput =
  Signal.map
    (Maybe.map (MsgForDownload << DoneDownloadHead) >> Maybe.withDefault NoOp)
    downloadHeadStream


port downloadTweetStream : Signal (Maybe TweetData)
port requestDownloadTweet : Signal (Maybe TweetIdentifier)
port requestDownloadTweet =
  let
    getRequest msg =
      case msg of
        MsgForDownload (DownloadTweet payload) ->
          Just payload

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


downloadTweetInput : Signal RootMsg.Msg
downloadTweetInput =
  Signal.map
    (Maybe.map (MsgForDownload << DoneDownloadTweet) >> Maybe.withDefault NoOp)
    downloadTweetStream


port downloadFollowBlockStream : Signal (Maybe FollowBlockData)
port requestDownloadFollowBlock : Signal (Maybe FollowBlockIdentifier)
port requestDownloadFollowBlock =
  let
    getRequest msg =
      case msg of
        MsgForDownload (DownloadFollowBlock payload) ->
          Just payload

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


downloadFollowBlockInput : Signal RootMsg.Msg
downloadFollowBlockInput =
  Signal.map
    (Maybe.map (MsgForDownload << DoneDownloadFollowBlock) >> Maybe.withDefault NoOp)
    downloadFollowBlockStream
