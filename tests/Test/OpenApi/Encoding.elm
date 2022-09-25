module Test.OpenApi.Encoding exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.Encoding
import Test exposing (..)


suite : Test
suite =
    let
        decodedEncoding : Result Json.Decode.Error OpenApi.Encoding.Encoding
        decodedEncoding =
            Json.Decode.decodeString OpenApi.Encoding.decode example
    in
    describe "Decodes an encoding object"
        [ test "contentType" <|
            \() ->
                decodedEncoding
                    |> Result.map OpenApi.Encoding.contentType
                    |> Expect.equal (Ok Nothing)
        , test "headers" <|
            \() ->
                decodedEncoding
                    |> Result.map (OpenApi.Encoding.headers >> Dict.isEmpty)
                    |> Expect.equal (Ok True)
        , test "style" <|
            \() ->
                decodedEncoding
                    |> Result.map OpenApi.Encoding.style
                    |> Expect.equal (Ok Nothing)
        , test "explode" <|
            \() ->
                decodedEncoding
                    |> Result.map OpenApi.Encoding.explode
                    |> Expect.equal (Ok False)
        , test "allowReserved" <|
            \() ->
                decodedEncoding
                    |> Result.map OpenApi.Encoding.allowReserved
                    |> Expect.equal (Ok False)
        ]


example : String
example =
    """{
  "requestBody": {
    "content": {
      "multipart/form-data": {
        "schema": {
          "type": "object",
          "properties": {
            "id": {
              "type": "string",
              "format": "uuid"
            },
            "address": {
              "type": "object",
              "properties": {}
            },
            "historyMetadata": {
              "description": "metadata in XML format",
              "type": "object",
              "properties": {}
            },
            "profileImage": {}
          },
          "encoding": {
            "historyMetadata": {
              "contentType": "application/xml; charset=utf-8"
            },
            "profileImage": {
              "contentType": ["image/png", "image/jpeg"],
              "headers": {
                "X-Rate-Limit-Limit": {
                  "description": "The number of allowed requests in the current period",
                  "schema": {
                    "type": "integer"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
"""
