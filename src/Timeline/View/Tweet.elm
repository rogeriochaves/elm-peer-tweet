module Timeline.View.Tweet (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Account.Model exposing (Head, Tweet)
import Time exposing (Time)
import DateTime.View.TimeDifference exposing (formatTimeDifference)
import Timeline.View.Avatar as Avatar
import Action as RootAction exposing (Action(ActionForRouter))
import Router.Action exposing (Action(UpdatePath))
import Router.Routes exposing (Sitemap(..))


view : Signal.Address RootAction.Action -> Time -> { head: Head, tweet: Tweet } -> Html
view address timestamp { head, tweet } =
  li
    [ class "collection-item tweet" ]
    [ Avatar.view head
    , div
        [ class "tweet-info" ]
        [ a
          [ class "title link", onClick address (ActionForRouter <| UpdatePath <| ProfileRoute head.hash) ]
          [ text head.n ]
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
