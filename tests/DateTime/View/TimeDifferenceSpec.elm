module DateTime.View.TimeDifferenceSpec exposing (..)

import Test exposing (..)
import Expect exposing (..)
import ElmTestBDDStyle exposing (..)
import DateTime.View.TimeDifference exposing (formatTimeDifference, day, month, year)
import Time exposing (Time, second, minute, hour)


timestamp : Time
timestamp =
    1457472396990


formatTimeMinus : Float -> Time -> String
formatTimeMinus amount multiplier =
    (formatTimeDifference timestamp (timestamp - (amount * multiplier)))


tests : Test
tests =
    describe "Timeline.View.Date"
        [ it "returns the correct formatted date for 1 second" <|
            expect (formatTimeMinus 1 second) to equal "1 second ago"
        , it "returns the correct formatted date for seconds" <|
            expect (formatTimeMinus 10 second) to equal "10 seconds ago"
        , it "returns the correct formatted date for minutes" <|
            expect (formatTimeMinus 6 minute) to equal "6 minutes ago"
        , it "returns the correct formatted date for hours" <|
            expect (formatTimeMinus 3 hour) to equal "3 hours ago"
        , it "returns the correct formatted date for days" <|
            expect (formatTimeMinus 12 day) to equal "12 days ago"
        , it "returns the correct formatted date for months" <|
            expect (formatTimeMinus 7 month) to equal "7 months ago"
        , it "returns the correct formatted date for years" <|
            expect (formatTimeMinus 1 year) to equal "1 year ago"
        ]
