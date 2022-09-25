module Test.OpenApi.Response exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.Response
import Test exposing (..)


suite : Test
suite =
    let
        decodedResponse : Result Json.Decode.Error OpenApi.Response.Response
        decodedResponse =
            Json.Decode.decodeString OpenApi.Response.decode example
    in
    describe "Decodes a response object"
        [ test "description" <|
            \() ->
                decodedResponse
                    |> Result.map OpenApi.Response.description
                    |> Expect.equal (Ok "a pet to be returned")
        , test "headers" <|
            \() ->
                decodedResponse
                    |> Result.map (OpenApi.Response.headers >> Dict.isEmpty)
                    |> Expect.equal (Ok True)
        , test "content" <|
            \() ->
                decodedResponse
                    |> Result.map (OpenApi.Response.content >> Dict.size)
                    |> Expect.equal (Ok 1)
        , test "links" <|
            \() ->
                decodedResponse
                    |> Result.map (OpenApi.Response.links >> Dict.size)
                    |> Expect.equal (Ok 0)
        ]


example : String
example =
    """{
    "description": "a pet to be returned",
    "content": {
      "application/json": {
        "schema": {
          "$ref": "#/components/schemas/Pet"
        }
      }
    }
}"""
