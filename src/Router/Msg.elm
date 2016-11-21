module Router.Msg exposing (Msg(..))

import Router.Routes exposing (Page)
import Navigation exposing (Location)


type Msg
    = Go Page
    | UrlChange Location
