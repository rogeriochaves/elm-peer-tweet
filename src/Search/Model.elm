module Search.Model exposing (Model, initialModel)


type alias Model =
    { query : String
    }


initialModel : Model
initialModel =
    { query = ""
    }
