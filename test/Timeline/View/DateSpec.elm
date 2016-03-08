module Timeline.View.DateSpec (..) where

import ElmTestBDDStyle exposing (..)
import Timeline.View.Date exposing (formatTimeDifference, day, month, year)
import Time exposing (second, minute, hour)
import Date exposing (Date, fromTime, toTime)


date : Date
date =
  fromTime 1457472396990


datePlus : Float -> Date
datePlus time =
  fromTime <| (toTime date) + time


tests : Test
tests =
  describe
    "Timeline.View.Date"
    [ it "returns the correct formatted date for 1 second"
        <| expect
            (formatTimeDifference date (datePlus <| 1 * second))
            toBe
            "1 second ago"
    , it "returns the correct formatted date for seconds"
        <| expect (formatTimeDifference date (datePlus <| 10 * second))
            toBe "10 seconds ago"
    , it "returns the correct formatted date for minutes"
        <| expect
            (formatTimeDifference date (datePlus <| 6 * minute))
            toBe
            "6 minutes ago"
    , it "returns the correct formatted date for hours"
        <| expect
            (formatTimeDifference date (datePlus <| 3 * hour))
            toBe
            "3 hours ago"
    , it "returns the correct formatted date for days"
        <| expect
            (formatTimeDifference date (datePlus <| 12 * day))
            toBe
            "12 days ago"
    , it "returns the correct formatted date for months"
        <| expect
            (formatTimeDifference date (datePlus <| 7 * month))
            toBe
            "7 months ago"
    , it "returns the correct formatted date for years"
        <| expect
            (formatTimeDifference date (datePlus year))
            toBe
            "1 year ago"
    ]
