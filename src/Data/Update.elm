module Data.Update (update) where

import Action as RootAction exposing (..)
import Data.Action as DataAction exposing (..)
import Data.Model exposing (Model, findAccount)
import Account.Update as AccountUpdate
import Account.Model as AccountModel exposing (HeadHash, initialModel)
import Account.Action as AccountAction exposing (..)
import Download.Action as DownloadAction exposing (..)
import List.Extra exposing (replaceIf)
import Time exposing (inMilliseconds)


update : RootAction.Action -> Model -> Model
update action model =
  let
    updateIn =
      updateAccount model
  in
    case action of
      ActionForData (ActionForAccount hash accountAction) ->
        updateIn hash accountAction

      ActionForData (UpdateUserAccount account) ->
        updateAccount model account.head.hash (Update account)

      ActionForData (CreateAccount hash timestamp) ->
        let
          initialModel =
            AccountModel.initialModel

          head =
            initialModel.head
        in
          updateIn hash (Update ({ initialModel | head = { head | hash = hash, d = round <| inMilliseconds timestamp } }))

      ActionForDownload (DoneDownloadHead head) ->
        updateIn head.hash (UpdateHead head)

      ActionForDownload (DoneDownloadTweet { headHash, tweet }) ->
        updateIn headHash (AddTweet tweet)

      ActionForDownload (DoneDownloadFollowBlock { headHash, followBlock }) ->
        updateIn headHash (AddFollowBlock followBlock)

      _ ->
        model


updateAccount : Model -> HeadHash -> AccountAction.Action -> List AccountModel.Model
updateAccount accounts hash action =
  let
    foundAccount =
      findAccount accounts (Just hash)
  in
    case foundAccount of
      Just account ->
        replaceIf (\x -> (Just x.head.hash) == (Just hash)) (AccountUpdate.update action account) accounts

      Nothing ->
        AccountUpdate.update action AccountModel.initialModel :: accounts
