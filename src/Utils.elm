module Utils where

isJust : Maybe a -> Bool
isJust a =
  case a of
    Just _ ->
      True

    Nothing ->
      False
