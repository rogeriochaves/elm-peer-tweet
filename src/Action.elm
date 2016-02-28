module Action where

import NewTweet.Action as NewTweet
import Data.Action as Data

type Action
    = NoOp
    | ActionForNewTweet NewTweet.Action
    | ActionForData Data.Action
