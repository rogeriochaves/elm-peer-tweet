module Data.Action where

import Data.Model as Data

type alias AddTweetRequestData =
  { data : Data.Model, text : String }

type Action
    = AddTweetRequest AddTweetRequestData
    | UpdateData Data.Model
