module NewTweet.Update (update) where

import Action as RootAction exposing (..)
import NewTweet.Action exposing (..)
import NewTweet.Model exposing (Model)

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForNewTweet (Update text) ->
      { model | text = text }
    _ ->
      model
