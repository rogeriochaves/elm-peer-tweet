module Settings.Model exposing (Model, initialModel)

import Account.Model as Account


type alias Model =
  { avatar : String
  }


initialModel : Maybe Account.Model -> Model
initialModel userAccount =
  let
    avatar =
      userAccount
        |> Maybe.map (.a << .head)
        |> Maybe.withDefault ""
  in
    { avatar = avatar
    }
