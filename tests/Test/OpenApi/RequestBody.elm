module Test.OpenApi.RequestBody exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.RequestBody
import Test exposing (..)


suite : Test
suite =
    let
        decodedRequestBody : Result Json.Decode.Error OpenApi.RequestBody.RequestBody
        decodedRequestBody =
            Json.Decode.decodeString OpenApi.RequestBody.decode example
    in
    describe "Decodes a request body object"
        [ test "description" <|
            \() ->
                decodedRequestBody
                    |> Result.map OpenApi.RequestBody.description
                    |> Expect.equal (Ok (Just "user to add to the system"))
        , test "content" <|
            \() ->
                decodedRequestBody
                    |> Result.map (OpenApi.RequestBody.content >> Dict.size)
                    |> Expect.equal (Ok 4)
        , test "required" <|
            \() ->
                decodedRequestBody
                    |> Result.map OpenApi.RequestBody.required
                    |> Expect.equal (Ok False)
        ]


example : String
example =
    """{
  "description": "user to add to the system",
  "content": {
    "application/json": {
      "schema": {
        "$ref": "#/components/schemas/User"
      },
      "examples": {
          "user" : {
            "summary": "User Example", 
            "externalValue": "https://foo.bar/examples/user-example.json"
          } 
        }
    },
    "application/xml": {
      "schema": {
        "$ref": "#/components/schemas/User"
      },
      "examples": {
          "user" : {
            "summary": "User example in XML",
            "externalValue": "https://foo.bar/examples/user-example.xml"
          }
        }
    },
    "text/plain": {
      "examples": {
        "user" : {
            "summary": "User example in Plain text",
            "externalValue": "https://foo.bar/examples/user-example.txt" 
        }
      } 
    },
    "*/*": {
      "examples": {
        "user" : {
            "summary": "User example in other format",
            "externalValue": "https://foo.bar/examples/user-example.whatever"
        }
      }
    }
  }
}"""
