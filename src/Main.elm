module Main (main) where

import View exposing (view)
import Model exposing (Model, initialModel)
import Msg exposing (Msg)
import StartApp
import Html exposing (Html)
import Update exposing (update)
import Task exposing (Task)
import Effects exposing (Never)
import Ports exposing (jsMailbox)
import Router.Update exposing (routeInput)
import Accounts.Ports exposing (accountInput)
import Publish.Ports exposing (requestPublish, publishHeadInput, publishTweetInput, publishFollowBlockInput)
import Download.Ports exposing (requestDownload, downloadErrorInput, downloadHeadInput, downloadTweetInput, downloadFollowBlockInput)
import DateTime.Signals exposing (updateDateTime)
import Authentication.Ports exposing (createdKeysInput, doneLoginInput)
import Accounts.Model as Accounts


-- App starting


inputs : List (Signal Msg)
inputs =
  [ routeInput
  , requestPublish
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


app : StartApp.App Model
app =
  StartApp.start
    { init = initialModel path userHash getStorage
    , update = update jsMailbox.address
    , view = view
    , inputs = inputs
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


port path : String
port userHash : Maybe String


port getStorage : Maybe Accounts.Model

port setStorage : Signal Accounts.Model
port setStorage =
  Signal.map .accounts app.model
