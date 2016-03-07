module HelloWorld where

import Graphics.Element exposing (Element, show)
import SignalConcatMap exposing (concatMap)
import Signal exposing (map)

helloWorld : Signal String
helloWorld =
  Signal.constant "hello"
    |> concatMap (\x -> Signal.constant <| x ++ " world")

main : Signal Element
main =
  helloWorld
    |> map show
