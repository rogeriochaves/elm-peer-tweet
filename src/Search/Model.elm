module Search.Model (Model, initialModel) where


type alias Model =
  { query : String
  }


initialModel : Model
initialModel =
  { query = ""
  }
