port module Main exposing (main)

import View exposing (view)
import Model exposing (Model, Flags, initialModel)
import Msg as RootMsg exposing (Msg(MsgForRouter))
import Update exposing (update)
import Accounts.Ports exposing (accountInput)
import Publish.Ports exposing (requestPublish, publishHeadInput, publishTweetInput, publishFollowBlockInput)
import Download.Ports exposing (requestDownload, downloadErrorInput, downloadHeadInput, downloadTweetInput, downloadFollowBlockInput)
import DateTime.Signals exposing (updateDateTime)
import Authentication.Ports exposing (createdKeysInput, doneLoginInput)
import Navigation
import Router.Msg exposing (Msg(UrlChange))


inputs : Sub RootMsg.Msg
inputs =
    Sub.batch
        [ requestPublish
        , accountInput
        , publishHeadInput
        , publishTweetInput
        , publishFollowBlockInput
        , requestDownload
        , downloadErrorInput
        , downloadHeadInput
        , downloadTweetInput
        , downloadFollowBlockInput
        , updateDateTime
        , createdKeysInput
        , doneLoginInput
        ]


main : Program Flags Model RootMsg.Msg
main =
    Navigation.programWithFlags (MsgForRouter << UrlChange)
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = always inputs
        }
