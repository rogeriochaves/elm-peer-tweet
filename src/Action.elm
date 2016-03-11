module Action (..) where

import NewTweet.Action as NewTweet
import Data.Action as Data
import Account.Action as Account
import Publish.Action as Publish
import Download.Action as Download
import DateTime.Action as DateTime


type Action
  = NoOp
  | ActionForNewTweet NewTweet.Action
  | ActionForData Data.Action
  | ActionForAccount Account.Action
  | ActionForPublish Publish.Action
  | ActionForDownload Download.Action
  | ActionForDateTime DateTime.Action
