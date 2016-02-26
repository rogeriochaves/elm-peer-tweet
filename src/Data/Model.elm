module Data.Model (Model, model) where

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
  { head: Maybe Head
  , tweets: List Tweet
  }

model : Model
model = { head = Nothing, tweets = [] }
