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
      updateAccounts model
  in
    case action of
      ActionForData (ActionForAccount hash accountAction) ->
        updateIn hash accountAction

      ActionForData (UpdateUserAccount account) ->
        { model
          | hash = account.head.hash
          , accounts = updateAccount model model.hash (Update account)
        }

      ActionForData (CreateAccount timestamp) ->
        let
          initialModel =
            AccountModel.initialModel

          head =
            initialModel.head
        in
          updateIn model.hash (Update ({ initialModel | head = { head | hash = model.hash, d = round <| inMilliseconds timestamp } }))

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
