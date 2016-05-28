module Accounts.Effects exposing (effects)

import Msg as RootMsg exposing (..)
import Accounts.Model exposing (Model, findAccount)
import Accounts.Msg exposing (Msg(CreateAccount, UpdateUserAccount))
import Task
import Effects exposing (Effects)
import Router.Routes exposing (Sitemap(TimelineRoute))
import Router.Msg exposing (Msg(UpdatePath))
import Publish.Msg exposing (Msg(PublishHead))


effects : Signal.Address RootMsg.Msg -> RootMsg.Msg -> Model -> Effects RootMsg.Msg
effects jsAddress msg _ =
  case msg of
    MsgForAccounts (CreateAccount _ _ _) ->
      Task.succeed (MsgForRouter <| UpdatePath <| TimelineRoute ())
        |> Effects.task

    MsgForAccounts (UpdateUserAccount userAccount) ->
      Task.succeed (MsgForPublish <| PublishHead <| .head <| userAccount)
        |> Effects.task

    MsgForAccounts accountsMsg ->
      Signal.send jsAddress (MsgForAccounts accountsMsg)
        |> Task.map (always RootMsg.NoOp)
        |> Effects.task

    _ ->
      Effects.none
