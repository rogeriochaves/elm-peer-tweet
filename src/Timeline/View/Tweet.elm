module Timeline.View.Tweet exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Account.Model exposing (Head, Tweet)
import Time exposing (Time)
import DateTime.View.TimeDifference exposing (formatTimeDifference)
import Timeline.View.Avatar as Avatar
import Msg as RootMsg exposing (Msg(MsgForRouter))
import Router.Msg exposing (Msg(Go))
import Router.Routes exposing (Page(..))


view : Time -> { head : Head, tweet : Tweet } -> Html RootMsg.Msg
view timestamp { head, tweet } =
    li [ class "collection-item tweet" ]
        [ Avatar.view head
        , div [ class "tweet-info" ]
            [ a [ class "title link", onClick (MsgForRouter <| Go <| ProfileRoute head.hash) ]
                [ text head.n ]
            , span [ class "secondary-content" ]
                [ text <| formatTimeDifference timestamp tweet.d
                ]
            , p []
                [ text tweet.t
                ]
            ]
        ]
