module Authentication.Action (..) where

import Authentication.Model exposing (Model, Keys)
import Account.Model exposing (HeadHash)


type Action
  = CreateKeys
  | UpdatePublicKey String
  | UpdateSecretKey String
  | DoneCreateKeys ( HeadHash, Keys )
