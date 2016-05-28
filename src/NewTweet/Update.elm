module NewTweet.Update exposing (update)

import Msg as RootMsg exposing (..)
import NewTweet.Msg exposing (..)
import NewTweet.Model exposing (Model)
import Accounts.Msg exposing (Msg(UpdateUserAccount))

update : RootMsg.Msg -> Model -> Model
update msg model =
  case msg of
    MsgForNewTweet (Update text) ->
      { model | text = text }

    MsgForAccounts (UpdateUserAccount _) ->
      { model | text = "" }

    _ ->
      model
