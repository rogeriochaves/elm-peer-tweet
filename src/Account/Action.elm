module Account.Action (..) where

import Account.Model exposing (Model, Head)


type Action
  = Update Model
  | UpdateHead Head
