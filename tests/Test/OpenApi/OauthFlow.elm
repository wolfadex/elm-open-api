module Test.OpenApi.OauthFlow exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.OauthFlow
import Test exposing (..)


suite : Test
suite =
    let
        decodedOauthFlow : Result Json.Decode.Error OpenApi.OauthFlow.OauthFlows
        decodedOauthFlow =
            Json.Decode.decodeString OpenApi.OauthFlow.decodeFlows example
    in
    describe "Decodes oauth flows"
        [ test "password" <|
            \() ->
                decodedOauthFlow
                    |> Result.map OpenApi.OauthFlow.password
                    |> Expect.equal (Ok Nothing)
        , test "clientCredentials" <|
            \() ->
                decodedOauthFlow
                    |> Result.map OpenApi.OauthFlow.clientCredentials
                    |> Expect.equal (Ok Nothing)
        , test "implicit authorizationUrl" <|
            \() ->
                decodedOauthFlow
                    |> Result.map (OpenApi.OauthFlow.implicit >> Maybe.map OpenApi.OauthFlow.implicitAuthorizationUrl)
                    |> Expect.equal (Ok (Just "https://example.com/api/oauth/dialog"))
        , test "implicit refreshUrl" <|
            \() ->
                decodedOauthFlow
                    |> Result.map (OpenApi.OauthFlow.implicit >> Maybe.map OpenApi.OauthFlow.implicitRefreshUrl)
                    |> Expect.equal (Ok (Just Nothing))
        , test "implicit scopes" <|
            \() ->
                decodedOauthFlow
                    |> Result.map (OpenApi.OauthFlow.implicit >> Maybe.map (OpenApi.OauthFlow.implicitScopes >> Dict.size))
                    |> Expect.equal (Ok (Just 2))
        , test "authorizationCode authorizationUrl" <|
            \() ->
                decodedOauthFlow
                    |> Result.map (OpenApi.OauthFlow.authorizationCode >> Maybe.map OpenApi.OauthFlow.authorizationCodeAuthorizationUrl)
                    |> Expect.equal (Ok (Just "https://example.com/api/oauth/dialog"))
        , test "authorizationCode tokenUrl" <|
            \() ->
                decodedOauthFlow
                    |> Result.map (OpenApi.OauthFlow.authorizationCode >> Maybe.map OpenApi.OauthFlow.authorizationCodeTokenUrl)
                    |> Expect.equal (Ok (Just "https://example.com/api/oauth/token"))
        , test "authorizationCode refreshUrl" <|
            \() ->
                decodedOauthFlow
                    |> Result.map (OpenApi.OauthFlow.authorizationCode >> Maybe.map OpenApi.OauthFlow.authorizationCodeRefreshUrl)
                    |> Expect.equal (Ok (Just Nothing))
        , test "authorizationCode scopes" <|
            \() ->
                decodedOauthFlow
                    |> Result.map (OpenApi.OauthFlow.authorizationCode >> Maybe.map (OpenApi.OauthFlow.authorizationCodeScopes >> Dict.size))
                    |> Expect.equal (Ok (Just 2))
        ]


example : String
example =
    """{
    "implicit": {
      "authorizationUrl": "https://example.com/api/oauth/dialog",
      "scopes": {
        "write:pets": "modify pets in your account",
        "read:pets": "read your pets"
      }
    },
    "authorizationCode": {
      "authorizationUrl": "https://example.com/api/oauth/dialog",
      "tokenUrl": "https://example.com/api/oauth/token",
      "scopes": {
        "write:pets": "modify pets in your account",
        "read:pets": "read your pets"
      }
    }
  }"""
