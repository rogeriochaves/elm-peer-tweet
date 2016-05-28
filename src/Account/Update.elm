module Account.Update exposing (update)

import Account.Msg exposing (..)
import Account.Model exposing (Model, addTweet, addFollowBlock)


update : Msg -> Model -> Model
update msg model =
  case msg of
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
