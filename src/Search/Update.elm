module Search.Update (update) where

import Action as RootAction exposing (..)
import Search.Action exposing (..)
import Search.Model exposing (Model)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForSearch (Update query) ->
      { model | query = query }

    _ ->
      model
