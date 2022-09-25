module Test.OpenApi.Parameter exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.Parameter
import Test exposing (..)


suite : Test
suite =
    let
        decodedParameter : Result Json.Decode.Error OpenApi.Parameter.Parameter
        decodedParameter =
            Json.Decode.decodeString OpenApi.Parameter.decode example1
    in
    describe "Decodes a parameter object"
        [ test "allowEmptyValue" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.allowEmptyValue
                    |> Expect.equal (Ok False)
        , test "description" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.description
                    |> Expect.equal (Ok (Just "token to be passed as a header"))
        , test "allowReserved" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.allowReserved
                    |> Expect.equal (Ok Nothing)
        , test "content" <|
            \() ->
                decodedParameter
                    |> Result.map (OpenApi.Parameter.content >> Dict.isEmpty)
                    |> Expect.equal (Ok True)
        , test "deprecated" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.deprecated
                    |> Expect.equal (Ok False)
        , test "example" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.example
                    |> Expect.equal (Ok "")
        , test "examples" <|
            \() ->
                decodedParameter
                    |> Result.map (OpenApi.Parameter.examples >> Dict.isEmpty)
                    |> Expect.equal (Ok True)
        , test "explode" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.explode
                    |> Expect.equal (Ok False)
        , test "in" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.in_
                    |> Expect.equal (Ok "header")
        , test "name" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.name
                    |> Expect.equal (Ok "token")
        , test "required" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.required
                    |> Expect.equal (Ok True)
        , test "schema" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.schema
                    |> Expect.ok
        , test "style" <|
            \() ->
                decodedParameter
                    |> Result.map OpenApi.Parameter.style
                    |> Expect.equal (Ok "simple")
        ]


{-| A header parameter with an array of 64 bit integer numbers:
-}
example1 : String
example1 =
    """{
  "name": "token",
  "in": "header",
  "description": "token to be passed as a header",
  "required": true,
  "schema": {
    "type": "array",
    "items": {
      "type": "integer",
      "format": "int64"
    }
  },
  "style": "simple"
}"""
