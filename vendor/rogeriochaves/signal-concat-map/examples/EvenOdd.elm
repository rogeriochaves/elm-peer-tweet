module EvenOdd where

import Graphics.Element exposing (Element, show)
import Time exposing (every, second)
import SignalConcatMap exposing (concatMap)
import Signal exposing (map)

evenSignal : Signal String
evenSignal = Signal.constant "even"

oddSignal : Signal String
oddSignal = Signal.constant "odd"

timelyEvenOddSignal : Signal String
timelyEvenOddSignal =
  (every <| 1 * second)
    |> map (round << (/) second)
    |> concatMap (\x -> if x % 2 == 0 then evenSignal else oddSignal)

main : Signal Element
main =
  timelyEvenOddSignal
    |> map show
