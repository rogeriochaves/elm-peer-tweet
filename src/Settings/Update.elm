module Settings.Update exposing (update)

import Msg as RootMsg exposing (..)
import Settings.Msg exposing (..)
import Settings.Model exposing (Model)
import Accounts.Msg exposing (Msg(UpdateUserAccount))

update : RootMsg.Msg -> Model -> Model
update msg model =
  case msg of
    MsgForSettings (UpdateAvatar avatar) ->
      { model | avatar = avatar }

    MsgForAccounts (UpdateUserAccount account) ->
      { model | avatar = account.head.a }

    _ ->
      model
