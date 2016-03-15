module Router.Update (..) where

import Router.Action as Router exposing (Action(..))
import Router.Model exposing (Model, Page(..), routeToPage, pathToPage)
import Action as RootAction exposing (Action(..))


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForRouter routerAction ->
      updateRouter routerAction model

    _ ->
      model


updateRouter : Router.Action -> Model -> Model
updateRouter action model =
  case action of
    PathChange path ->
      { page = pathToPage path }

    UpdatePath route ->
      model
