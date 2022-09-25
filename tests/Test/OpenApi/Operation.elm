module Test.OpenApi.Operation exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.Operation
import Test exposing (..)


suite : Test
suite =
    let
        decodedOperation : Result Json.Decode.Error OpenApi.Operation.Operation
        decodedOperation =
            Json.Decode.decodeString OpenApi.Operation.decode example
    in
    describe "Decodes an Operation object"
        [ test "tags" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.tags
                    |> Expect.equal (Ok [ "pet" ])
        , test "summary" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.summary
                    |> Expect.equal (Ok (Just "Updates a pet in the store with form data"))
        , test "description" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.description
                    |> Expect.equal (Ok Nothing)
        , test "externalDocs" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.externalDocs
                    |> Expect.equal (Ok Nothing)
        , test "operationId" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.operationId
                    |> Expect.equal (Ok (Just "updatePetWithForm"))
        , test "parameters" <|
            \() ->
                decodedOperation
                    |> Result.map (OpenApi.Operation.parameters >> List.length)
                    |> Expect.equal (Ok 1)
        , test "requestBody" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.requestBody
                    |> Expect.ok
        , test "responses" <|
            \() ->
                decodedOperation
                    |> Result.map (OpenApi.Operation.responses >> Dict.size)
                    |> Expect.equal (Ok 2)
        , test "callbacks" <|
            \() ->
                decodedOperation
                    |> Result.map (OpenApi.Operation.callbacks >> Dict.size)
                    |> Expect.equal (Ok 0)
        , test "deprecated" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.deprecated
                    |> Expect.equal (Ok False)
        , test "security" <|
            \() ->
                decodedOperation
                    |> Result.map (OpenApi.Operation.security >> List.length)
                    |> Expect.equal (Ok 1)
        , test "servers" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.servers
                    |> Expect.equal (Ok [])
        ]


example : String
example =
    """{
  "tags": [
    "pet"
  ],
  "summary": "Updates a pet in the store with form data",
  "operationId": "updatePetWithForm",
  "parameters": [
    {
      "name": "petId",
      "in": "path",
      "description": "ID of pet that needs to be updated",
      "required": true,
      "schema": {
        "type": "string"
      }
    }
  ],
  "requestBody": {
    "content": {
      "application/x-www-form-urlencoded": {
        "schema": {
          "type": "object",
          "properties": {
            "name": { 
              "description": "Updated name of the pet",
              "type": "string"
            },
            "status": {
              "description": "Updated status of the pet",
              "type": "string"
            }
          },
          "required": ["status"] 
        }
      }
    }
  },
  "responses": {
    "200": {
      "description": "Pet updated.",
      "content": {
        "application/json": {},
        "application/xml": {}
      }
    },
    "405": {
      "description": "Method Not Allowed",
      "content": {
        "application/json": {},
        "application/xml": {}
      }
    }
  },
  "security": [
    {
      "petstore_auth": [
        "write:pets",
        "read:pets"
      ]
    }
  ]
}"""
