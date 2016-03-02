module Action where

import NewTweet.Action as NewTweet
import Data.Action as Data
import Publish.Action as Publish

type Action
    = NoOp
    | ActionForNewTweet NewTweet.Action
    | ActionForData Data.Action
    | ActionForPublish Publish.Action
