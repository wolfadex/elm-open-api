module Test.OpenApi.Operation exposing (suite)

import Dict
import Expect
import Json.Decode
import Json.Encode
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
                    |> Result.map (OpenApi.Operation.security >> Maybe.map List.length)
                    |> Expect.equal (Ok (Just 1))
        , describe "when 'security' is unspecified" <|
            [ test "it decodes to Nothing" <|
                \() ->
                    Json.Decode.decodeString OpenApi.Operation.decode securityUnspecifiedExample
                        |> Result.map OpenApi.Operation.security
                        |> Expect.equal (Ok Nothing)
            , test "it is not encoded" <|
                \() ->
                    Json.Decode.decodeString OpenApi.Operation.decode securityUnspecifiedExample
                        |> Result.map (OpenApi.Operation.encode >> Json.Encode.encode 0)
                        |> Result.andThen (Json.Decode.decodeString OpenApi.Operation.decode)
                        |> Result.map OpenApi.Operation.security
                        |> Expect.equal (Ok Nothing)
            ]
        , test "servers" <|
            \() ->
                decodedOperation
                    |> Result.map OpenApi.Operation.servers
                    |> Expect.equal (Ok [])
        , test "gh failing?" <|
            \() ->
                Json.Decode.decodeString OpenApi.Operation.decode failingExample
                    |> Expect.ok
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


securityUnspecifiedExample : String
securityUnspecifiedExample =
    """{
  "summary": "Updates a pet in the store with form data",
  "operationId": "updatePetWithForm",
  "responses": {
    "200": {
      "description": "Pet updated.",
      "content": {}
    }
  }
}"""


failingExample : String
failingExample =
    """{
        "summary": "List check suites for a Git reference",
        "description": "**Note:** The Checks API only looks for pushes in the repository where the check suite or check run were created. Pushes to a branch in a forked repository are not detected and return an empty `pull_requests` array and a `null` value for `head_branch`.\\n\\nLists check suites for a commit `ref`. The `ref` can be a SHA, branch name, or a tag name. GitHub Apps must have the `checks:read` permission on a private repository or pull access to a public repository to list check suites. OAuth Apps and authenticated users must have the `repo` scope to get check suites in a private repository.",
        "tags": ["checks"],
        "operationId": "checks/list-suites-for-ref",
        "externalDocs": {
          "description": "API method documentation",
          "url": "https://docs.github.com/rest/reference/checks#list-check-suites-for-a-git-reference"
        },
        "parameters": [
          {
            "$ref": "#/components/parameters/owner"
          },
          {
            "$ref": "#/components/parameters/repo"
          },
          {
            "name": "ref",
            "description": "ref parameter",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string"
            },
            "x-multi-segment": true
          },
          {
            "name": "app_id",
            "description": "Filters check suites by GitHub App `id`.",
            "in": "query",
            "required": false,
            "schema": {
              "type": "integer"
            },
            "example": 1
          },
          {
            "$ref": "#/components/parameters/check-name"
          },
          {
            "$ref": "#/components/parameters/per-page"
          },
          {
            "$ref": "#/components/parameters/page"
          }
        ],
        "responses": {
          "200": {
            "description": "Response",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "required": ["total_count", "check_suites"],
                  "properties": {
                    "total_count": {
                      "type": "integer"
                    },
                    "check_suites": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/check-suite"
                      }
                    }
                  }
                },
                "examples": {
                  "default": {
                    "$ref": "#/components/examples/check-suite-paginated"
                  }
                }
              }
            },
            "headers": {
              "Link": {
                "$ref": "#/components/headers/link"
              }
            }
          }
        },
        "x-github": {
          "githubCloudOnly": false,
          "enabledForGitHubApps": true,
          "category": "checks",
          "subcategory": "suites"
        }
      }"""
