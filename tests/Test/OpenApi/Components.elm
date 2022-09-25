module Test.OpenApi.Components exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.Components
import Test exposing (..)


suite : Test
suite =
    let
        decodedComponents : Result Json.Decode.Error OpenApi.Components.Components
        decodedComponents =
            Json.Decode.decodeString OpenApi.Components.decode example
    in
    describe "Decodes a components object"
        [ test "schemas" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.schemas >> Dict.size)
                    |> Expect.equal (Ok 3)
        , test "parameters" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.parameters >> Dict.size)
                    |> Expect.equal (Ok 2)
        , test "responses" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.responses >> Dict.size)
                    |> Expect.equal (Ok 3)
        , test "securitySchemes" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.securitySchemes >> Dict.size)
                    |> Expect.equal (Ok 2)
        , test "examples" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.examples >> Dict.size)
                    |> Expect.equal (Ok 0)
        , test "requestBodies" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.requestBodies >> Dict.size)
                    |> Expect.equal (Ok 0)
        , test "headers" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.headers >> Dict.size)
                    |> Expect.equal (Ok 0)
        , test "links" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.links >> Dict.size)
                    |> Expect.equal (Ok 0)
        , test "callbacks" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.callbacks >> Dict.size)
                    |> Expect.equal (Ok 0)
        , test "pathItems" <|
            \() ->
                decodedComponents
                    |> Result.map (OpenApi.Components.pathItems >> Dict.size)
                    |> Expect.equal (Ok 0)
        ]


example : String
example =
    """{
  "schemas": {
    "GeneralError": {
      "type": "object",
      "properties": {
        "code": {
          "type": "integer",
          "format": "int32"
        },
        "message": {
          "type": "string"
        }
      }
    },
    "Category": {
      "type": "object",
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "name": {
          "type": "string"
        }
      }
    },
    "Tag": {
      "type": "object",
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "name": {
          "type": "string"
        }
      }
    }
  },
  "parameters": {
    "skipParam": {
      "name": "skip",
      "in": "query",
      "description": "number of items to skip",
      "required": true,
      "schema": {
        "type": "integer",
        "format": "int32"
      }
    },
    "limitParam": {
      "name": "limit",
      "in": "query",
      "description": "max records to return",
      "required": true,
      "schema" : {
        "type": "integer",
        "format": "int32"
      }
    }
  },
  "responses": {
    "NotFound": {
      "description": "Entity not found."
    },
    "IllegalInput": {
      "description": "Illegal input for operation."
    },
    "GeneralError": {
      "description": "General Error",
      "content": {
        "application/json": {
          "schema": {
            "$ref": "#/components/schemas/GeneralError"
          }
        }
      }
    }
  },
  "securitySchemes": {
    "api_key": {
      "type": "apiKey",
      "name": "api_key",
      "in": "header"
    },
    "petstore_auth": {
      "type": "oauth2",
      "flows": {
        "implicit": {
          "authorizationUrl": "https://example.org/api/oauth/dialog",
          "scopes": {
            "write:pets": "modify pets in your account",
            "read:pets": "read your pets"
          }
        }
      }
    }
  }
}"""
