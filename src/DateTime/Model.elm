module DateTime.Model exposing (Model, initialModel)

import Time exposing (Time)


type alias Model =
  { timestamp : Time
  }


initialModel : Model
initialModel =
  { timestamp = 0
  }
