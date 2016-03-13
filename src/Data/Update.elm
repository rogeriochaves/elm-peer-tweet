module Data.Update (..) where

import Action as RootAction exposing (..)
import Data.Action as DataAction exposing (..)
import Data.Model exposing (Model, findAccount)
import Account.Update as AccountUpdate
import Account.Model as AccountModel exposing (HeadHash)
import Account.Action as AccountAction exposing (..)
import Download.Action as DownloadAction exposing (..)
import Task
import Effects exposing (Effects)
import List.Extra exposing (replaceIf)


update : RootAction.Action -> Model -> Model
update action model =
  let
    updateIn =
      updateAccounts model
  in
    case action of
      ActionForData (ActionForAccount hash accountAction) ->
        updateIn hash accountAction

      ActionForData (UpdateUserAccount account) ->
        updateIn model.hash (Update account)

      ActionForDownload (DoneDownloadHead head) ->
        updateIn head.hash (UpdateHead head)

      ActionForDownload (DoneDownloadTweet { headHash, tweet }) ->
        updateIn headHash (AddTweet tweet)

      ActionForDownload (DoneDownloadFollowBlock { headHash, followBlock }) ->
        updateIn headHash (AddFollowBlock followBlock)

      _ ->
        model


updateAccounts : Model -> HeadHash -> AccountAction.Action -> Model
updateAccounts model hash action =
  { model
    | accounts = updateAccount model hash action
  }


updateAccount : Model -> HeadHash -> AccountAction.Action -> List AccountModel.Model
updateAccount model hash action =
  let
    foundAccount =
      findAccount model (Just hash)
  in
    case foundAccount of
      Just account ->
        replaceIf (\x -> x.head.hash == hash) (AccountUpdate.update action account) model.accounts

      Nothing ->
        AccountUpdate.update action AccountModel.initialModel :: model.accounts


effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForData dataAction ->
      Signal.send jsAddress (ActionForData dataAction)
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
