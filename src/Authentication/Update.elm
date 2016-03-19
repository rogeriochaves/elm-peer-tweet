module Authentication.Update (update) where

import Action as RootAction exposing (..)
import Authentication.Action exposing (Action(DoneCreateKeys))
import Authentication.Model exposing (Model)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForAuthentication (DoneCreateKeys ( hash, keys )) ->
      { model | hash = (Just hash), keys = (Just keys) }

    _ ->
      model
