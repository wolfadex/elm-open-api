module Test.OpenApi.Server.Variable exposing (suite)

import Dict exposing (Dict)
import Expect
import Json.Decode
import OpenApi.Server
import OpenApi.Server.Variable
import Test exposing (..)


suite : Test
suite =
    let
        decodedVariables : Result Json.Decode.Error (Dict String OpenApi.Server.Variable.Variable)
        decodedVariables =
            Json.Decode.decodeString OpenApi.Server.decode example
                |> Result.map OpenApi.Server.variables
    in
    describe "Decodes server variable objects"
        [ test "keys" <|
            \() ->
                decodedVariables
                    |> Result.map Dict.keys
                    |> Expect.equal (Ok [ "basePath", "port", "username" ])
        , test "username default" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "username" >> Maybe.map OpenApi.Server.Variable.default)
                    |> Expect.equal (Ok (Just "demo"))
        , test "username description" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "username" >> Maybe.andThen OpenApi.Server.Variable.description)
                    |> Expect.equal (Ok (Just "this value is assigned by the service provider, in this example `gigantic-server.com`"))
        , test "username enum" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "username" >> Maybe.map OpenApi.Server.Variable.enum)
                    |> Expect.equal (Ok (Just []))
        , test "port default" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "port" >> Maybe.map OpenApi.Server.Variable.default)
                    |> Expect.equal (Ok (Just "8443"))
        , test "port description" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "port" >> Maybe.map OpenApi.Server.Variable.description)
                    |> Expect.equal (Ok (Just Nothing))
        , test "port enum" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "port" >> Maybe.map OpenApi.Server.Variable.enum)
                    |> Expect.equal (Ok (Just [ "8443", "443" ]))
        , test "basePath default" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "basePath" >> Maybe.map OpenApi.Server.Variable.default)
                    |> Expect.equal (Ok (Just "v2"))
        , test "basePath description" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "basePath" >> Maybe.map OpenApi.Server.Variable.description)
                    |> Expect.equal (Ok (Just Nothing))
        , test "basePath enum" <|
            \() ->
                decodedVariables
                    |> Result.map (Dict.get "basePath" >> Maybe.map OpenApi.Server.Variable.enum)
                    |> Expect.equal (Ok (Just []))
        ]


example : String
example =
    """{
      "url": "https://{username}.gigantic-server.com:{port}/{basePath}",
      "description": "The production API server",
      "variables": {
        "username": {
          "default": "demo",
          "description": "this value is assigned by the service provider, in this example `gigantic-server.com`"
        },
        "port": {
          "enum": [
            "8443",
            "443"
          ],
          "default": "8443"
        },
        "basePath": {
          "default": "v2"
        }
      }
    }"""
