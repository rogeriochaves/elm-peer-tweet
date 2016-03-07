module Data.Model where

import Maybe exposing (andThen, map, withDefault)


type alias Hash = String


type alias Head =
  { hash: Hash
  , next: List Hash
  }


type alias Tweet =
  { hash: Hash
  , t: String
  , next: List Hash
  }


type alias Model =
  { head: Head
  , tweets: List Tweet
  }


initialModel : Model
initialModel =
  { head = { hash = "", next = [] }
  , tweets = []
  }


nextHash : Maybe { b | next : List Hash } -> Maybe Hash
nextHash hash = hash `andThen` (List.head << .next)


nextHashToDownload : Model -> Hash -> Maybe Hash
nextHashToDownload model hash =
  let
    tweet = findTweet model (Just hash)
    next = nextHash tweet
  in
    case tweet of
      Nothing -> Just hash
      Just tweet ->
        case next of
          Nothing -> Nothing
          Just hash -> nextHashToDownload model hash


findTweet : Model -> Maybe Hash -> Maybe Tweet
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
    Just _ -> model
    Nothing -> { model | tweets = tweet :: model.tweets }
