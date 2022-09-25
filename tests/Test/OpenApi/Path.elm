module Test.OpenApi.Path exposing (suite)

import Expect
import Json.Decode
import OpenApi.Path
import Test exposing (..)


suite : Test
suite =
    let
        decodedPath : Result Json.Decode.Error OpenApi.Path.Path
        decodedPath =
            Json.Decode.decodeString OpenApi.Path.decode exampleGet
    in
    describe "Decodes a Path object"
        [ test "description" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.description
                    |> Expect.equal (Ok Nothing)
        , test "summary" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.summary
                    |> Expect.equal (Ok Nothing)
        , test "get" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.get
                    |> Expect.ok
        , test "put" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.put
                    |> Expect.equal (Ok Nothing)
        , test "post" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.post
                    |> Expect.equal (Ok Nothing)
        , test "delete" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.delete
                    |> Expect.equal (Ok Nothing)
        , test "options" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.options
                    |> Expect.equal (Ok Nothing)
        , test "head" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.head
                    |> Expect.equal (Ok Nothing)
        , test "patch" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.patch
                    |> Expect.equal (Ok Nothing)
        , test "trace" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.trace
                    |> Expect.equal (Ok Nothing)
        , test "servers" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.servers
                    |> Expect.equal (Ok [])
        , test "parameters" <|
            \() ->
                decodedPath
                    |> Result.map OpenApi.Path.parameters
                    |> Expect.ok
        ]


exampleGet : String
exampleGet =
    """{
  "get": {
    "description": "Returns pets based on ID",
    "summary": "Find pets by ID",
    "operationId": "getPetsById",
    "responses": {
      "200": {
        "description": "pet response",
        "content": {
          "*/*": {
            "schema": {
              "type": "array",
              "items": {
                "$ref": "#/components/schemas/Pet"
              }
            }
          }
        }
      },
      "default": {
        "description": "error payload",
        "content": {
          "text/html": {
            "schema": {
              "$ref": "#/components/schemas/ErrorModel"
            }
          }
        }
      }
    }
  },
  "parameters": [
    {
      "name": "id",
      "in": "path",
      "description": "ID of pet to use",
      "required": true,
      "schema": {
        "type": "array",
        "items": {
          "type": "string"
        }
      },
      "style": "simple"
    }
  ]
}"""
