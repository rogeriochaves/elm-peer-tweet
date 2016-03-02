module Ports where

import Action exposing (..)

jsMailbox : Signal.Mailbox Action.Action
jsMailbox = Signal.mailbox NoOp

isJust : Maybe a -> Bool
isJust a =
  case a of
    Just _ -> True
    Nothing -> False

filterEmpty : Signal (Maybe a) -> Signal (Maybe a)
filterEmpty = Signal.filter isJust Nothing
