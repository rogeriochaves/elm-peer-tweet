module NewTweet.Model exposing (Model, initialModel)

type alias Model =
  { text: String
  }

initialModel : Model
initialModel =
  { text = ""
  }
