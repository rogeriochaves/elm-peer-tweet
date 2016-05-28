module Authentication.Msg exposing (..)

import Authentication.Model exposing (Model, Keys)
import Account.Model exposing (HeadHash)


type Msg
  = CreateKeys
  | DoneCreateKeys { hash : HeadHash, keys : Keys }
  | UpdatePublicKey String
  | UpdateSecretKey String
  | UpdateName String
  | Login Keys
  | DoneLogin HeadHash
