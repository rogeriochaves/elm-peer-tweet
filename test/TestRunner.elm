module Main where

import Task
import Console exposing (..)
import Graphics.Element exposing (Element)
import ElmTest exposing (..)

import Data.UpdateSpec

tests : Test
tests =
  Data.UpdateSpec.tests

main : Element
main =
  elementRunner tests

port runner : Signal (Task.Task x ())
port runner =
  Console.run <| consoleRunner tests
