module Timeline.View.Tweet (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Account.Model exposing (Head, Tweet)
import Time exposing (Time)
import DateTime.View.TimeDifference exposing (formatTimeDifference)
import Timeline.View.Avatar as Avatar


view : Time -> { head: Head, tweet: Tweet } -> Html
view timestamp { head, tweet } =
  li
    [ class "collection-item tweet" ]
    [ Avatar.view head
    , div
        [ class "tweet-info" ]
        [ span [ class "title" ] [ text head.n ]
        , span
            [ class "secondary-content" ]
            [ text <| formatTimeDifference timestamp <| toFloat tweet.d
            ]
        , p
            []
            [ text tweet.t
            ]
        ]
    ]
