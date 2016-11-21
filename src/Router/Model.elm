module Router.Model exposing (..)

import Router.Routes exposing (Page(..))


type alias Model =
    { page : Page
    }


initialModel : Page -> Model
initialModel page =
    { page = page
    }
