module Test.OpenApi.SecurityScheme exposing (suite)

import Expect
import Json.Decode
import OpenApi.SecurityScheme exposing (SecuritySchemeIn(..), SecuritySchemeType(..))
import Test exposing (..)


suite : Test
suite =
    describe "Decodes a security scheme"
        [ describe "of basic auth"
            (let
                decodedSecurityScheme : Result Json.Decode.Error OpenApi.SecurityScheme.SecurityScheme
                decodedSecurityScheme =
                    Json.Decode.decodeString OpenApi.SecurityScheme.decode exampleBasicAuth
             in
             [ test "type_" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.type_
                        |> Expect.equal (Ok (Http { scheme = "basic", bearerFormat = Nothing }))
             , test "description" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.description
                        |> Expect.equal (Ok Nothing)
             ]
            )
        , describe "of api key"
            (let
                decodedSecurityScheme : Result Json.Decode.Error OpenApi.SecurityScheme.SecurityScheme
                decodedSecurityScheme =
                    Json.Decode.decodeString OpenApi.SecurityScheme.decode exampleApiKey
             in
             [ test "type_" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.type_
                        |> Expect.equal (Ok (ApiKey { name = "api_key", in_ = Header }))
             , test "description" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.description
                        |> Expect.equal (Ok Nothing)
             ]
            )
        , describe "of jwt bearer"
            (let
                decodedSecurityScheme : Result Json.Decode.Error OpenApi.SecurityScheme.SecurityScheme
                decodedSecurityScheme =
                    Json.Decode.decodeString OpenApi.SecurityScheme.decode exampleJwtBearer
             in
             [ test "type_" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.type_
                        |> Expect.equal (Ok (Http { scheme = "bearer", bearerFormat = Just "JWT" }))
             , test "description" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.description
                        |> Expect.equal (Ok Nothing)
             ]
            )
        , describe "of implicit oauth"
            (let
                decodedSecurityScheme : Result Json.Decode.Error OpenApi.SecurityScheme.SecurityScheme
                decodedSecurityScheme =
                    Json.Decode.decodeString OpenApi.SecurityScheme.decode exampleImplicitOAuth
             in
             [ test "type_" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.type_
                        |> Expect.ok
             , test "description" <|
                \() ->
                    decodedSecurityScheme
                        |> Result.map OpenApi.SecurityScheme.description
                        |> Expect.equal (Ok Nothing)
             ]
            )
        ]


exampleBasicAuth : String
exampleBasicAuth =
    """{
  "type": "http",
  "scheme": "basic"
}"""


exampleApiKey : String
exampleApiKey =
    """{
  "type": "apiKey",
  "name": "api_key",
  "in": "header"
}"""


exampleJwtBearer : String
exampleJwtBearer =
    """{
  "type": "http",
  "scheme": "bearer",
  "bearerFormat": "JWT"
}"""


exampleImplicitOAuth : String
exampleImplicitOAuth =
    """{
  "type": "oauth2",
  "flows": {
    "implicit": {
      "authorizationUrl": "https://example.com/api/oauth/dialog",
      "scopes": {
        "write:pets": "modify pets in your account",
        "read:pets": "read your pets"
      }
    }
  }
}"""
