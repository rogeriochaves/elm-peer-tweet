module Download.Msg exposing (..)

import Account.Model exposing (Hash, HeadHash, TweetHash, FollowBlockHash, Head, Tweet, FollowBlock)
import Account.Msg exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


type Msg
    = BeginDownload
    | DownloadHead HeadHash
    | DoneDownloadHead Head
    | DownloadTweet TweetIdentifier
    | DoneDownloadTweet TweetData
    | DownloadFollowBlock FollowBlockIdentifier
    | DoneDownloadFollowBlock FollowBlockData
    | ErrorDownload Hash String
