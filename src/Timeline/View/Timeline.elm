module Timeline.View.Timeline where

import Html exposing (Html, div, text)
import Data.Model exposing (Model)
import Timeline.View.Tweet as Tweet

view : Model -> Html
view model =
  div []
    (List.map Tweet.view model.tweets)
