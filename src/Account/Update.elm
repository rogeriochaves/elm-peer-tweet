module Account.Update (update, effects) where

import Action as RootAction exposing (..)
import Account.Action exposing (..)
import Download.Action as DownloadAction exposing (..)
import Account.Model exposing (Model, addTweet)
import Effects exposing (Effects)
import Task exposing (Task)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForAccount (UpdateAccount account) ->
      account

    ActionForDownload downloadAction ->
      updateDownloadedAccount downloadAction model

    _ ->
      model


updateDownloadedAccount : DownloadAction.Action -> Model -> Model
updateDownloadedAccount action model =
  case action of
    DoneDownloadHead head ->
      { model | head = head }

    DoneDownloadTweet tweet ->
      addTweet model tweet

    _ ->
      model


effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForAccount accountAction ->
      Signal.send jsAddress (ActionForAccount accountAction)
        |> Task.toMaybe
        |> Task.map (always NoOp)
        |> Effects.task

    _ ->
      Effects.none
