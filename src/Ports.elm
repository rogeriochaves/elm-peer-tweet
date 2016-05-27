module Ports (..) where

import Msg exposing (..)


jsMailbox : Signal.Mailbox Msg.Msg
jsMailbox =
  Signal.mailbox NoOp
