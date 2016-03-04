module Download.Model (Model, initialModel) where

type alias Model =
  { downloadingCount: Int
  }

initialModel : Model
initialModel =
  { downloadingCount = 0
  }
