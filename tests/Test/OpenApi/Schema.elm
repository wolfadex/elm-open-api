module Test.OpenApi.Schema exposing (suite)

import Expect
import Json.Decode
import OpenApi.Schema
import Test exposing (..)


suite : Test
suite =
    let
        decodedSchema : Result Json.Decode.Error OpenApi.Schema.Schema
        decodedSchema =
            Json.Decode.decodeString OpenApi.Schema.decode example
    in
    describe "Decodes a schema object"
        [ test "doesn't break" <|
            \() ->
                decodedSchema
                    |> Expect.ok
        ]


example : String
example =
    """{
  "ErrorModel": {
    "type": "object",
    "required": ["message", "code"],
    "properties": {
      "message": {
        "type": "string"
      },
      "code": {
        "type": "integer",
        "minimum": 100,
        "maximum": 600
      }
    }
  }
}"""
