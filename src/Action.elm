module Action where

import NewTweet.Action as NewTweet
import Data.Action as Data
import Sync.Action as Sync

type Action
    = NoOp
    | ActionForNewTweet NewTweet.Action
    | ActionForData Data.Action
    | ActionForSync Sync.Action
