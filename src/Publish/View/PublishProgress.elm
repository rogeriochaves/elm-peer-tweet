module Publish.View.PublishProgress where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Action as RootAction exposing (..)
import Publish.Model exposing (Model)

view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  div [class "sidebar-item ion-upload down"] [
    model.publishingCount
      |> toString
      |> text
  ]
