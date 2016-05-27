module Authentication.Effects (effects) where

import Msg as RootMsg exposing (..)
import Authentication.Msg exposing (Msg(CreateKeys, DoneLogin))
import Task
import Effects exposing (Effects)
import Download.Msg exposing (Msg(DownloadHead))


effects : Signal.Address RootMsg.Msg -> RootMsg.Msg -> Effects RootMsg.Msg
effects jsAddress msg =
  case msg of
    MsgForAuthentication (DoneLogin hash) ->
      Task.succeed (MsgForDownload <| DownloadHead hash)
        |> Effects.task

    MsgForAuthentication authenticationMsg ->
      Signal.send jsAddress (MsgForAuthentication authenticationMsg)
        |> Task.map (always RootMsg.NoOp)
        |> Effects.task

    _ ->
      Effects.none
