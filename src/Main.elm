module Main (main) where

import View exposing (view)
import Model exposing (Model, initialModel)
import Action exposing (Action)
import StartApp
import Html exposing (Html)
import Update exposing (update)
import Task exposing (Task)
import Effects exposing (Never)
import Ports exposing (jsMailbox)
import Account.Ports exposing (accountInput)
import Publish.Ports exposing (requestPublish, publishHeadInput, publishTweetInput)
import Download.Ports exposing (requestDownload, downloadHeadInput, downloadTweetInput)
import DateTime.Signals exposing (updateDateTime)


-- App starting


inputs : List (Signal Action)
inputs =
  [ requestPublish
  , accountInput
  , publishHeadInput
  , publishTweetInput
  , requestDownload
  , downloadHeadInput
  , downloadTweetInput
  , updateDateTime
  ]


app : StartApp.App Model
app =
  StartApp.start
    { init = initialModel
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
