module Data.Action where

import Data.Model as Data

type Action
    = AddTweetRequest { data : Data.Model, text : String }
    | UpdateData Data.Model
