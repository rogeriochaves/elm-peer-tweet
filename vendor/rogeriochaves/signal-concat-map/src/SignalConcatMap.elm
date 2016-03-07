module SignalConcatMap
  (concatMap, (>>=), (=<<)) where

{-| ConcatMap for Elm Signals

# Tests
@docs concatMap, (>>=), (=<<)

-}

import Native.SignalConcatMap

{-| Maps a signal creator function over a signal and concatenates the result -}
concatMap : (a -> Signal b) -> Signal a -> Signal b
concatMap = Native.SignalConcatMap.concatMap

{-| Infix notation for concatMap, taking the signal first -}
(>>=) : Signal a -> (a -> Signal b) -> Signal b
(>>=) = flip concatMap

{-| Infix notation for concatMap, taking the sinal last -}
(=<<) : (a -> Signal b) -> Signal a -> Signal b
(=<<) = concatMap
