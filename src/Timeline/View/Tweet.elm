module Timeline.View.Tweet (..) where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Data.Model exposing (Tweet)
import Time exposing (Time)
import DateTime.View.TimeDifference exposing (formatTimeDifference)


view : Time -> Tweet -> Html
view timestamp tweet =
  div
    [ class "tweet" ]
    [ text "Fulano"
    , div
        [ class "minutes-ago" ]
        [ text <| formatTimeDifference timestamp <| toFloat tweet.d
        ]
    , div
        []
        [ text tweet.t
        ]
    , div
        [ class "avatar" ]
        [ div [ class "default-avatar ion-person" ] []
        ]
    ]
