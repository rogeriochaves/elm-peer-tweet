module Authentication.Model exposing (..)

import Account.Model exposing (HeadHash, Name)


type alias Keys =
  { publicKey : String, secretKey : String }


type alias Model =
  { hash : Maybe HeadHash
  , keys : Keys
  , name : Name
  }


initialModel : Maybe String -> Model
initialModel hash =
  { hash = hash
  , keys = { publicKey = "", secretKey = "" }
  , name = ""
  }
