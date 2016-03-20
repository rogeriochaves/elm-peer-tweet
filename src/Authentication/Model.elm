module Authentication.Model (..) where

import Account.Model exposing (HeadHash)


type alias Keys =
  { publicKey : String, secretKey : String }


type alias Model =
  { hash : Maybe HeadHash
  , keys : Keys
  }


initialModel : Maybe String -> Model
initialModel hash =
  { hash = hash
  , keys = { publicKey = "", secretKey = "" }
  }
