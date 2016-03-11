module Data.Update (..) where

import Action as RootAction exposing (..)
import Data.Action as DataAction exposing (..)
import Data.Model exposing (Model)
import Account.Update as AccountUpdate


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForData (DataAction.ActionForAccount hash accountAction) ->
      { model
        | accounts =
            List.map
              (\x ->
                if x.head.hash == hash then
                  AccountUpdate.update (RootAction.ActionForAccount accountAction) x
                else
                  x
              )
              model.accounts
      }

    _ ->
      model
