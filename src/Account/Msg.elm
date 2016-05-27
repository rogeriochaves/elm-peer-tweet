module Account.Msg (..) where

import Account.Model exposing (Model, Head, Tweet, FollowBlock, HeadHash, TweetHash, FollowBlockHash)


type alias TweetIdentifier =
  { headHash : HeadHash, tweetHash : TweetHash }


type alias TweetData =
  { headHash : HeadHash, tweet : Tweet }


type alias FollowBlockIdentifier =
  { headHash : HeadHash, followBlockHash : FollowBlockHash }


type alias FollowBlockData =
  { headHash : HeadHash, followBlock : FollowBlock }


type Msg
  = Update Model
  | UpdateHead Head
  | AddTweet Tweet
  | AddFollowBlock FollowBlock
