module Test.OpenApi.Header exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.Header
import Test exposing (..)


suite : Test
suite =
    let
        decodedHeader : Result Json.Decode.Error OpenApi.Header.Header
        decodedHeader =
            Json.Decode.decodeString OpenApi.Header.decode example
    in
    describe "Decodes a header object"
        [ test "style" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.style
                    |> Expect.equal (Ok (Just "simple"))
        , test "description" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.description
                    |> Expect.equal (Ok (Just "token to be passed as a header"))
        , test "explode" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.explode
                    |> Expect.equal (Ok False)
        , test "required" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.required
                    |> Expect.equal (Ok False)
        , test "deprecated" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.deprecated
                    |> Expect.equal (Ok False)
        , test "allowEmptyValue" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.allowEmptyValue
                    |> Expect.equal (Ok False)
        , test "schema" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.schema
                    |> Expect.ok
        , test "content" <|
            \() ->
                decodedHeader
                    |> Result.map (OpenApi.Header.content >> Dict.size)
                    |> Expect.equal (Ok 0)
        , test "example" <|
            \() ->
                decodedHeader
                    |> Result.map OpenApi.Header.example
                    |> Expect.equal (Ok "")
        , test "examples" <|
            \() ->
                decodedHeader
                    |> Result.map (OpenApi.Header.examples >> Dict.size)
                    |> Expect.equal (Ok 0)
        ]


example : String
example =
    """{
  "description": "token to be passed as a header",
  "schema": {
    "type": "array",
    "items": {
      "type": "integer",
      "format": "int64"
    }
  },
  "style": "simple"
}"""
