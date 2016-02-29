module Data.Update (update, effects) where

import Action as RootAction exposing (..)
import Data.Action exposing (..)
import Data.Model exposing (Model)
import Effects exposing (Effects)
import Task exposing (Task)

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForData (UpdateData data) ->
      data
    _ ->
      model

effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForData (AddTweetRequest request) ->
      Signal.send jsAddress (ActionForData (AddTweetRequest request))
        |> Task.toMaybe
        |> Task.map (\_ -> NoOp)
        |> Effects.task
    _ ->
      Effects.none
