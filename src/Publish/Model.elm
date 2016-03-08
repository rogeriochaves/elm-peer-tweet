module Publish.Model (Model, initialModel) where


type alias Model =
  { publishingCount : Int
  }


initialModel : Model
initialModel =
  { publishingCount = 0
  }
