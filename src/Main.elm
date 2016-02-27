module Main (main) where

import View exposing (view)
import Html exposing (Html)
import Data.Model as Data

main : Html
main =
  view

port data : Data.Model
