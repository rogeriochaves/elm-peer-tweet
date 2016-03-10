module Data.Action (..) where

import Data.Model as Data exposing (Hash)


type alias AddTweetRequestData =
  { data : Data.Model, text : String }


type alias AddFollowerRequestData =
  { data : Data.Model, hash : Hash }


type Action
  = AddTweetRequest AddTweetRequestData
  | AddFollowerRequest AddFollowerRequestData
  | UpdateData Data.Model
