module Authentication.Action (..) where

import Authentication.Model exposing (Model, Keys)
import Account.Model exposing (HeadHash)


type Action
  = CreateKeys
  | DoneCreateKeys { hash : HeadHash, keys : Keys }
  | UpdatePublicKey String
  | UpdateSecretKey String
  | UpdateName String
  | Login Keys
  | DoneLogin HeadHash
