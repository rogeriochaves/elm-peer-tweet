module Download.View.DownloadProgress exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Msg as RootMsg exposing (..)
import Download.Model exposing (Model, downloadingItemsCount)


view : Model -> Html RootMsg.Msg
view model =
    div [ class "sidebar-status ion-ios-cloud-download down" ]
        [ downloadingItemsCount model
            |> toString
            |> text
        ]
