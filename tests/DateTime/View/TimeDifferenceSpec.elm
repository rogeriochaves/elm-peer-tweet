module DateTime.View.TimeDifferenceSpec exposing (..)

import ElmTestBDDStyle exposing (..)
import DateTime.View.TimeDifference exposing (formatTimeDifference, day, month, year)
import Time exposing (Time, second, minute, hour)


timestamp : Time
timestamp =
    1457472396990


tests : Test
tests =
    describe "Timeline.View.Date"
        [ it "returns the correct formatted date for 1 second" <|
            expect (formatTimeDifference timestamp (timestamp - 1 * second))
                toBe
                "1 second ago"
        , it "returns the correct formatted date for seconds" <|
            expect (formatTimeDifference timestamp (timestamp - 10 * second))
                toBe
                "10 seconds ago"
        , it "returns the correct formatted date for minutes" <|
            expect (formatTimeDifference timestamp (timestamp - 6 * minute))
                toBe
                "6 minutes ago"
        , it "returns the correct formatted date for hours" <|
            expect (formatTimeDifference timestamp (timestamp - 3 * hour))
                toBe
                "3 hours ago"
        , it "returns the correct formatted date for days" <|
            expect (formatTimeDifference timestamp (timestamp - 12 * day))
                toBe
                "12 days ago"
        , it "returns the correct formatted date for months" <|
            expect (formatTimeDifference timestamp (timestamp - 7 * month))
                toBe
                "7 months ago"
        , it "returns the correct formatted date for years" <|
            expect (formatTimeDifference timestamp (timestamp - year))
                toBe
                "1 year ago"
        ]
