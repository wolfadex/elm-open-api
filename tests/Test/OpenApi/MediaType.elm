module Test.OpenApi.MediaType exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.MediaType
import Test exposing (..)


suite : Test
suite =
    let
        decodedMediaType : Result Json.Decode.Error OpenApi.MediaType.MediaType
        decodedMediaType =
            Json.Decode.decodeString OpenApi.MediaType.decode exampleApplicationJson
    in
    describe "Decodes a media type object"
        [ test "schema" <|
            \() ->
                decodedMediaType
                    |> Result.map OpenApi.MediaType.schema
                    |> Expect.ok
        , test "example" <|
            \() ->
                decodedMediaType
                    |> Result.map OpenApi.MediaType.example
                    |> Expect.equal (Ok Nothing)
        , test "examples" <|
            \() ->
                decodedMediaType
                    |> Result.map (OpenApi.MediaType.examples >> Dict.size)
                    |> Expect.equal (Ok 3)
        , test "encoding" <|
            \() ->
                decodedMediaType
                    |> Result.map (OpenApi.MediaType.encoding >> Dict.isEmpty)
                    |> Expect.equal (Ok True)
        ]


exampleApplicationJson : String
exampleApplicationJson =
    """{
    "schema": {
      "$ref": "#/components/schemas/Pet"
    },
    "examples": {
      "cat": {
        "summary": "An example of a cat",
        "value": {
          "name": "Fluffy",
          "petType": "Cat",
          "color": "White",
          "gender": "male",
          "breed": "Persian"
        }
      },
      "dog": {
        "summary": "An example of a dog with a cat's name",
        "value": {
          "name": "Puma",
          "petType": "Dog",
          "color": "Black",
          "gender": "Female",
          "breed": "Mixed"
        }
      },
      "frog": {
        "$ref": "#/components/examples/frog-example"
      }
    }
  }"""
