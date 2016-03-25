module Settings.View.Settings (..) where

import Html exposing (..)
import Model exposing (Model)
import Account.Model as Account
import Topbar.View.Topbar as Topbar
import Action exposing (Action)


view : Signal.Address Action -> Model -> Account.Model -> Html
view address model userAccount =
  div
    []
    [ Topbar.view address model "Settings"
    ]
