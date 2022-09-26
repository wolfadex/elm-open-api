module Test.OpenApi.Callback exposing (suite)

import Expect
import Json.Decode
import OpenApi.Callback
import Test exposing (..)


suite : Test
suite =
    let
        decodedCallback : Result Json.Decode.Error OpenApi.Callback.Callback
        decodedCallback =
            Json.Decode.decodeString OpenApi.Callback.decode example
    in
    describe "Decodes a callback object"
        [ test "expression" <|
            \() ->
                decodedCallback
                    |> Result.map OpenApi.Callback.expression
                    |> Expect.equal (Ok "{$request.query.queryUrl}")
        , test "value" <|
            \() ->
                decodedCallback
                    |> Result.map OpenApi.Callback.value
                    |> Expect.ok
        ]


example : String
example =
    """{
  "{$request.query.queryUrl}": {
    "post": {
      "requestBody": {
        "description": "Callback payload",
        "content": {
          "application/json": {
            "schema": {
              "$ref": "#/components/schemas/SomePayload"
            }
          }
        }
      },
      "responses": {
        "200": {
          "description": "callback successfully processed"
        }
      }
    }
  }
}
"""
