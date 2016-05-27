module Msg (..) where

import Router.Msg as Router
import NewTweet.Msg as NewTweet
import Accounts.Msg as Accounts
import Publish.Msg as Publish
import Download.Msg as Download
import DateTime.Msg as DateTime
import Search.Msg as Search
import Authentication.Msg as Authentication
import Settings.Msg as Settings


type Msg
  = NoOp
  | MsgForRouter Router.Msg
  | MsgForNewTweet NewTweet.Msg
  | MsgForAccounts Accounts.Msg
  | MsgForPublish Publish.Msg
  | MsgForDownload Download.Msg
  | MsgForDateTime DateTime.Msg
  | MsgForSearch Search.Msg
  | MsgForAuthentication Authentication.Msg
  | MsgForSettings Settings.Msg
