module Publish.Model exposing (Model, initialModel)


type alias Model =
  { publishingCount : Int
  }


initialModel : Model
initialModel =
  { publishingCount = 0
  }
