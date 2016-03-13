module Account.Model (..) where

import Maybe exposing (andThen, map, withDefault)


type alias Hash =
  String


type alias HeadHash =
  Hash


type alias TweetHash =
  Hash


type alias FollowBlockHash =
  Hash


type alias Timestamp =
  Int


type alias Head =
  { hash : HeadHash
  , d : Timestamp
  , next : List TweetHash
  , f : List FollowBlockHash
  }


type alias Tweet =
  { hash : TweetHash
  , t : String
  , d : Timestamp
  , next : List TweetHash
  }


type alias FollowBlock =
  { hash : FollowBlockHash
  , l : List HeadHash
  , next : List FollowBlockHash
  }


type alias Model =
  { head : Head
  , tweets : List Tweet
  , followBlocks : List FollowBlock
  }


initialModel : Model
initialModel =
  { head = { hash = "", d = 0, next = [], f = [] }
  , tweets = []
  , followBlocks = []
  }


nextHash : Maybe { b | next : List Hash } -> Maybe Hash
nextHash hash =
  hash `andThen` (List.head << .next)


nextHashToDownload : Model -> Hash -> Maybe Hash
nextHashToDownload model hash =
  let
    tweet =
      findTweet model (Just hash)

    next =
      nextHash tweet
  in
    case tweet of
      Nothing ->
        Just hash

      Just tweet ->
        next `andThen` (nextHashToDownload model)


nextFollowBlockHashToDownload : Model -> Hash -> Maybe Hash
nextFollowBlockHashToDownload model hash =
  let
    followBlock =
      findFollowBlock model (Just hash)

    next =
      nextHash followBlock
  in
    case followBlock of
      Nothing ->
        Just hash

      Just followBlock ->
        next `andThen` (nextFollowBlockHashToDownload model)


findTweet : Model -> Maybe TweetHash -> Maybe Tweet
findTweet model hash =
  case hash of
    Just hash ->
      List.filter (\t -> t.hash == hash) model.tweets
        |> List.head

    Nothing ->
      Nothing


addTweet : Model -> Tweet -> Model
addTweet model tweet =
  case (findTweet model (Just tweet.hash)) of
    Just _ ->
      model

    Nothing ->
      { model | tweets = tweet :: model.tweets }


findFollowBlock : Model -> Maybe FollowBlockHash -> Maybe FollowBlock
findFollowBlock model hash =
  case hash of
    Just hash ->
      List.filter (\t -> t.hash == hash) model.followBlocks
        |> List.head

    Nothing ->
      Nothing


firstFollowBlock : Model -> Maybe FollowBlock
firstFollowBlock account =
  List.head account.head.f
    |> findFollowBlock account
