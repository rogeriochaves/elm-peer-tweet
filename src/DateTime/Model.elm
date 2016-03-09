module DateTime.Model (Model, initialModel) where

import Time exposing (Time)


type alias Model =
  { timestamp : Time
  }


initialModel : Model
initialModel =
  { timestamp = 0
  }
