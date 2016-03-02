module Main (main) where

import View exposing (view)
import Model exposing (Model, initialModel)
import StartApp
import Html exposing (Html)
import Publish.Signals exposing (requestPublish)
import Update exposing (update)
import Task exposing (Task)
import Effects exposing (Never)
import Ports exposing (jsMailbox)
import Data.Ports exposing (dataInput)
import Publish.Ports exposing (publishHeadInput, publishTweetInput)

-- App starting

app : StartApp.App Model
app = StartApp.start
  { init = initialModel
  , update = update jsMailbox.address
  , view = view
  , inputs = [requestPublish, dataInput, publishHeadInput, publishTweetInput] }

main : Signal Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
