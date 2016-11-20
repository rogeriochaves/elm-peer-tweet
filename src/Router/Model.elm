module Router.Model exposing (..)

import Router.Routes exposing (Page(..))
import Navigation


type alias Model =
    { history : List Navigation.Location
    }


initialModel : Navigation.Location -> Model
initialModel location =
    { history = [ location ]
    }
