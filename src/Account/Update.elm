module Account.Update (update) where

import Account.Action exposing (..)
import Account.Model exposing (Model, addTweet)


update : Action -> Model -> Model
update action model =
  case action of
    UpdateAccount account ->
      account
