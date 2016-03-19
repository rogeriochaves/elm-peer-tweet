module Authentication.Model (..) where

import Account.Model exposing (HeadHash)


type alias Keys =
  { publicKey : String, privateKey : String }


type alias Model =
  { hash : Maybe HeadHash
  , keys : Maybe Keys
  }


initialModel : Maybe String -> Model
initialModel userHash =
  { hash = Nothing
  , keys = Nothing
  }
