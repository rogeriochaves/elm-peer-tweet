module Download.Action (..) where

import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Head, Tweet, FollowBlock)


type alias DownloadTweetPayload =
  { headHash : HeadHash, tweetHash : TweetHash }


type alias DoneDownloadTweetPayload =
  { headHash : HeadHash, tweet : Tweet }


type alias DownloadFollowBlockPayload =
  { headHash : HeadHash, followBlockHash : FollowBlockHash }


type alias DoneDownloadFollowBlockPayload =
  { headHash : HeadHash, followBlock : FollowBlock }


type Action
  = BeginDownload
  | DownloadHead HeadHash
  | DoneDownloadHead Head
  | DownloadTweet DownloadTweetPayload
  | DoneDownloadTweet DoneDownloadTweetPayload
  | DownloadFollowBlock DownloadFollowBlockPayload
  | DoneDownloadFollowBlock DoneDownloadFollowBlockPayload
