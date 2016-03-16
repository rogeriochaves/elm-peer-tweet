module Action (..) where

import Router.Action as Router
import NewTweet.Action as NewTweet
import Data.Action as Data
import Publish.Action as Publish
import Download.Action as Download
import DateTime.Action as DateTime
import Search.Action as Search


type Action
  = NoOp
  | ActionForRouter Router.Action
  | ActionForNewTweet NewTweet.Action
  | ActionForData Data.Action
  | ActionForPublish Publish.Action
  | ActionForDownload Download.Action
  | ActionForDateTime DateTime.Action
  | ActionForSearch Search.Action
