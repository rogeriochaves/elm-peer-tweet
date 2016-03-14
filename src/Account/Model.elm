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


nextHash : Maybe { a | next : List Hash } -> Maybe Hash
nextHash hash =
  hash `andThen` (List.head << .next)


findItem : List { a | hash : Hash } -> Maybe Hash -> Maybe { a | hash : Hash }
findItem list hash =
  case hash of
    Just hash ->
      List.filter (\t -> t.hash == hash) list
        |> List.head

    Nothing ->
      Nothing


nextItemToDownload : List { a | hash : Hash, next : List Hash } -> Hash -> Maybe Hash
nextItemToDownload list hash =
  let
    item =
      findItem list (Just hash)

    next =
      nextHash item
  in
    case item of
      Nothing ->
        Just hash

      Just item ->
        next `andThen` (nextItemToDownload list)


findTweet : Model -> Maybe TweetHash -> Maybe Tweet
findTweet model =
  findItem model.tweets


nextHashToDownload : Model -> Hash -> Maybe Hash
nextHashToDownload model =
  nextItemToDownload model.tweets


addTweet : Model -> Tweet -> Model
addTweet model tweet =
  case (findTweet model (Just tweet.hash)) of
    Just _ ->
      model

    Nothing ->
      { model | tweets = tweet :: model.tweets }


findFollowBlock : Model -> Maybe FollowBlockHash -> Maybe FollowBlock
findFollowBlock model =
  findItem model.followBlocks


nextFollowBlockHashToDownload : Model -> Hash -> Maybe Hash
nextFollowBlockHashToDownload model =
  nextItemToDownload model.followBlocks


firstFollowBlock : Model -> Maybe FollowBlock
firstFollowBlock account =
  List.head account.head.f
    |> findFollowBlock account


addFollowBlock : Model -> FollowBlock -> Model
addFollowBlock model followBlock =
  case (findFollowBlock model (Just followBlock.hash)) of
    Just _ ->
      model

    Nothing ->
      { model | followBlocks = followBlock :: model.followBlocks }
