module Account.Update (update) where

import Account.Action exposing (..)
import Account.Model exposing (Model, addTweet, addFollowBlock)


update : Action -> Model -> Model
update action model =
  case action of
    Update account ->
      if account.head.d > model.head.d then
        account
      else
        model

    UpdateHead head ->
      if head.d > model.head.d then
        { model | head = head }
      else
        model

    AddTweet tweet ->
      addTweet model tweet

    AddFollowBlock followBlock ->
      addFollowBlock model followBlock
