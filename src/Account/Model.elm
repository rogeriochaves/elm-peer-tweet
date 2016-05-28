module Account.Model exposing (..)

import Maybe exposing (andThen, map, withDefault)
import Utils.Utils exposing (isJust)


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


type alias Name =
  String


type alias AvatarUrl =
  String


type alias Head =
  { hash : HeadHash
  , d : Timestamp
  , next : List TweetHash
  , f : List FollowBlockHash
  , n : Name
  , a : AvatarUrl
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
  { head = { hash = "", d = 0, next = [], f = [], n = "", a = "" }
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


nextHashToDownload : List { a | hash : Hash, next : List Hash } -> Hash -> Maybe Hash
nextHashToDownload list hash =
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
        next `andThen` (nextHashToDownload list)


addTweet : Model -> Tweet -> Model
addTweet account tweet =
  case (findItem account.tweets (Just tweet.hash)) of
    Just _ ->
      account

    Nothing ->
      { account | tweets = tweet :: account.tweets }


firstFollowBlock : Model -> Maybe FollowBlock
firstFollowBlock account =
  List.head account.head.f
    |> findItem account.followBlocks


addFollowBlock : Model -> FollowBlock -> Model
addFollowBlock account followBlock =
  case (findItem account.followBlocks (Just followBlock.hash)) of
    Just _ ->
      account

    Nothing ->
      { account | followBlocks = followBlock :: account.followBlocks }


followList : Model -> List HeadHash
followList account =
  List.concatMap .l account.followBlocks


isFollowing : HeadHash -> Model -> Bool
isFollowing hash account =
  List.filter ((==) hash) (followList account)
    |> List.head
    |> isJust
