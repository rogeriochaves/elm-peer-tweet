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
