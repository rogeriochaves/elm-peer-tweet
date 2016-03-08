module Timeline.View.Date (..) where

import Date exposing (Date, toTime)
import Time exposing (second, minute, hour)


day : Float
day =
  hour * 24


month : Float
month =
  day * 30


year : Float
year =
  day * 365


formatTimeDifference : Date -> Date -> String
formatTimeDifference from to =
  let
    diff = (toTime to) - (toTime from)
    seconds = diff / second |> truncate
    minutes = diff / minute |> truncate
    hours = diff / hour |> truncate
    days = diff / day |> truncate
    months = diff / month |> truncate
    years = diff / year |> truncate
  in
    if diff < second then
      "just now"
    else if diff < minute then
      (seconds |> toString) ++ " " ++ (pluralize "second" seconds) ++ " ago"
    else if diff < hour then
      (minutes |> toString) ++ " " ++ (pluralize "minute" minutes) ++ " ago"
    else if diff < day then
      (hours |> toString) ++ " " ++ (pluralize "hour" hours) ++ " ago"
    else if diff < month then
      (days |> toString) ++ " " ++ (pluralize "day" days) ++ " ago"
    else if diff < year then
      (months |> toString) ++ " " ++ (pluralize "month" months) ++ " ago"
    else
      (years |> toString) ++ " " ++ (pluralize "year" years) ++ " ago"


pluralize : String -> Int -> String
pluralize text count =
  if count == 1 then
    text
  else
    text ++ "s"
