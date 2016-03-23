module Ports (..) where

import Action exposing (..)


jsMailbox : Signal.Mailbox Action.Action
jsMailbox =
  Signal.mailbox NoOp
