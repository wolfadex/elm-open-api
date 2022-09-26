module Test.OpenApi.Example exposing (suite)

import Expect
import Json.Decode
import OpenApi.Example
import Test exposing (..)


suite : Test
suite =
    let
        decodedExample : Result Json.Decode.Error OpenApi.Example.Example
        decodedExample =
            Json.Decode.decodeString OpenApi.Example.decode example
    in
    describe "Decodes an example object"
        [ test "summary" <|
            \() ->
                decodedExample
                    |> Result.map OpenApi.Example.summary
                    |> Expect.equal (Ok (Just "A foo example"))
        , test "description" <|
            \() ->
                decodedExample
                    |> Result.map OpenApi.Example.description
                    |> Expect.equal (Ok Nothing)
        , test "value" <|
            \() ->
                decodedExample
                    |> Result.map OpenApi.Example.value
                    |> Expect.ok
        , test "externalValue" <|
            \() ->
                decodedExample
                    |> Result.map OpenApi.Example.externalValue
                    |> Expect.equal (Ok Nothing)
        ]


example : String
example =
    """{
  "summary": "A foo example",
  "value": { "foo": "bar" }
}"""
