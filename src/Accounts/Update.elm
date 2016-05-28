module Accounts.Update exposing (update)

import Msg as RootMsg exposing (..)
import Accounts.Msg as AccountsMsg exposing (..)
import Accounts.Model exposing (Model, findAccount)
import Account.Update as AccountUpdate
import Account.Model as AccountModel exposing (HeadHash, initialModel)
import Account.Msg as AccountMsg exposing (..)
import Download.Msg as DownloadMsg exposing (..)
import List.Extra exposing (replaceIf)
import Time exposing (inMilliseconds)


update : RootMsg.Msg -> Model -> Model
update msg model =
    let
        updateIn =
            updateAccount model
    in
        case msg of
            MsgForAccounts (MsgForAccount hash accountMsg) ->
                updateIn hash accountMsg

            MsgForAccounts (UpdateUserAccount account) ->
                updateAccount model account.head.hash (Update account)

            MsgForAccounts (CreateAccount hash name timestamp) ->
                let
                    initialModel =
                        AccountModel.initialModel

                    head =
                        initialModel.head

                    newHead =
                        { head
                            | hash = hash
                            , n = name
                            , d = round <| inMilliseconds timestamp
                        }
                in
                    updateIn hash <| Update { initialModel | head = newHead }

            MsgForDownload (DoneDownloadHead head) ->
                updateIn head.hash (UpdateHead head)

            MsgForDownload (DoneDownloadTweet { headHash, tweet }) ->
                updateIn headHash (AddTweet tweet)

            MsgForDownload (DoneDownloadFollowBlock { headHash, followBlock }) ->
                updateIn headHash (AddFollowBlock followBlock)

            _ ->
                model


updateAccount : Model -> HeadHash -> AccountMsg.Msg -> List AccountModel.Model
updateAccount accounts hash msg =
    let
        foundAccount =
            findAccount accounts (Just hash)
    in
        case foundAccount of
            Just account ->
                replaceIf (\x -> (Just x.head.hash) == (Just hash)) (AccountUpdate.update msg account) accounts

            Nothing ->
                AccountUpdate.update msg AccountModel.initialModel :: accounts
