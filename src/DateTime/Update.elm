module DateTime.Update (update) where

import Action as RootAction exposing (..)
import DateTime.Action exposing (..)
import DateTime.Model exposing (Model)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForDateTime (Update time) ->
      { model | timestamp = time }

    _ ->
      model
