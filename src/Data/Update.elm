module Data.Update (update) where

import Action as RootAction exposing (..)
import Data.Action exposing (..)
import Data.Model exposing (Model)

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForData (UpdateData data) -> data
    _ -> model
