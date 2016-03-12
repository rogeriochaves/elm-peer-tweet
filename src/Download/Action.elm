module Download.Action (..) where

import Account.Model exposing (HeadHash, TweetHash, Head, Tweet)


type alias DownloadTweetPayload =
  { headHash : HeadHash, tweetHash : TweetHash }


type alias DoneDownloadTweetPayload =
  { headHash : HeadHash, tweet : Tweet }


type Action
  = BeginDownload
  | DownloadHead HeadHash
  | DoneDownloadHead Head
  | DownloadTweet DownloadTweetPayload
  | DoneDownloadTweet DoneDownloadTweetPayload
