module Data.Update (..) where

import Action as RootAction exposing (..)
import Data.Action as DataAction exposing (..)
import Data.Model exposing (Model, findAccount)
import Account.Update as AccountUpdate
import Account.Model as AccountModel exposing (HeadHash)
import Account.Action as AccountAction exposing (..)
import Task
import Effects exposing (Effects)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForData (ActionForAccount hash accountAction) ->
      { model
        | accounts = updateAccount model hash accountAction
      }

    ActionForData (UpdateUserAccount account) ->
      { model
        | hash = account.head.hash
        , accounts = updateAccount model model.hash (Update account)
      }

    _ ->
      model


updateAccount : Model -> HeadHash -> AccountAction.Action -> List AccountModel.Model
updateAccount model hash action =
  let
    foundAccount =
      findAccount model (Just hash)

    accounts =
      model.accounts
  in
    case foundAccount of
      Just _ ->
        List.map
          (\account ->
            if account.head.hash == hash then
              AccountUpdate.update action account
            else
              account
          )
          accounts

      Nothing ->
        AccountUpdate.update action AccountModel.initialModel :: accounts


effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForData dataAction ->
      Signal.send jsAddress (ActionForData dataAction)
        |> Task.toMaybe
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
