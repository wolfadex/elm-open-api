module Test.OpenApi exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import OpenApi
import Test exposing (..)


suite : Test
suite =
    describe "Decodes any OpenAPI json string"
        [ test "carl" <|
            \() -> Expect.equal True True
        ]
