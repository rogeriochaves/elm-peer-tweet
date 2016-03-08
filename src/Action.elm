module Action (..) where

import NewTweet.Action as NewTweet
import Data.Action as Data
import Publish.Action as Publish
import Download.Action as Download


type Action
  = NoOp
  | ActionForNewTweet NewTweet.Action
  | ActionForData Data.Action
  | ActionForPublish Publish.Action
  | ActionForDownload Download.Action
