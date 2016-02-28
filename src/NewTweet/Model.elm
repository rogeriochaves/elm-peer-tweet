module NewTweet.Model (Model, initialModel) where

type alias Model =
  { text: String
  }

initialModel : Model
initialModel =
  { text = ""
  }
