module Action (..) where

import Router.Action as Router
import NewTweet.Action as NewTweet
import Accounts.Action as Accounts
import Publish.Action as Publish
import Download.Action as Download
import DateTime.Action as DateTime
import Search.Action as Search
import Authentication.Action as Authentication
import Settings.Action as Settings


type Action
  = NoOp
  | ActionForRouter Router.Action
  | ActionForNewTweet NewTweet.Action
  | ActionForAccounts Accounts.Action
  | ActionForPublish Publish.Action
  | ActionForDownload Download.Action
  | ActionForDateTime DateTime.Action
  | ActionForSearch Search.Action
  | ActionForAuthentication Authentication.Action
  | ActionForSettings Settings.Action
