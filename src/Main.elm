port module Main exposing (main)

import View exposing (view)
import Model exposing (Model, Flags, initialModel)
import Msg exposing (Msg)
import Update exposing (update)
import Accounts.Ports exposing (accountInput)
import Publish.Ports exposing (requestPublish, publishHeadInput, publishTweetInput, publishFollowBlockInput)
import Download.Ports exposing (requestDownload, downloadErrorInput, downloadHeadInput, downloadTweetInput, downloadFollowBlockInput)
import DateTime.Signals exposing (updateDateTime)
import Authentication.Ports exposing (createdKeysInput, doneLoginInput)
import Navigation
import Router.Update as Router
import Router.Routes exposing (urlParser)


inputs : Sub Msg
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


main : Program Flags
main =
    Navigation.programWithFlags urlParser
        { init = initialModel
        , view = view
        , update = update
        , urlUpdate = Router.update
        , subscriptions = always inputs
        }
