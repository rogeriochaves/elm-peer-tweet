module Download.Action (..) where

import Account.Model exposing (Hash, HeadHash, TweetHash, FollowBlockHash, Head, Tweet, FollowBlock)
import Account.Action exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


type Action
  = BeginDownload
  | DownloadHead HeadHash
  | DoneDownloadHead Head
  | DownloadTweet TweetIdentifier
  | DoneDownloadTweet TweetData
  | DownloadFollowBlock FollowBlockIdentifier
  | DoneDownloadFollowBlock FollowBlockData
  | ErrorDownload Hash String
