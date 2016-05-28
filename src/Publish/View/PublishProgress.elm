module Publish.View.PublishProgress exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Msg as RootMsg exposing (..)
import Publish.Model exposing (Model)

view : Signal.Address RootMsg.Msg -> Model -> Html
view address model =
  div [class "sidebar-status ion-upload down"] [
    model.publishingCount
      |> toString
      |> text
  ]
