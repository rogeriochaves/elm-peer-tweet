module Data.Model where

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

nextHash : { b | next : List a } -> Maybe a
nextHash = List.head << .next

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
