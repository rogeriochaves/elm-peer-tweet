module Download.Ports where

import Data.Model as Data exposing (Head, Tweet, Hash)
import Action as RootAction exposing (..)
import Download.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)
import Download.Action exposing (..)
import Time exposing (every, second)

requestDownload : Signal RootAction.Action
requestDownload =
  (every <| 30 * second)
    |> Signal.map (\_ -> ActionForDownload BeginDownload)

port downloadHeadStream : Signal (Maybe Head)

port requestDownloadHead : Signal (Maybe Hash)
port requestDownloadHead =
  let getRequest action =
    case action of
      ActionForDownload (DownloadHead hash) -> Just hash
      _ -> Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty

downloadHeadInput : Signal RootAction.Action
downloadHeadInput =
  Signal.map (Maybe.map (ActionForDownload << DoneDownloadHead) >> Maybe.withDefault NoOp) downloadHeadStream

port downloadTweetStream : Signal (Maybe Tweet)

port requestDownloadTweet : Signal (Maybe Hash)
port requestDownloadTweet =
  let getRequest action =
    case action of
      ActionForDownload (DownloadTweet hash) -> Just hash
      _ -> Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty

downloadTweetInput : Signal RootAction.Action
downloadTweetInput =
  Signal.map (Maybe.map (ActionForDownload << DoneDownloadTweet) >> Maybe.withDefault NoOp) downloadTweetStream
