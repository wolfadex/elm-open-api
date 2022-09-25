module Test.OpenApi.Server exposing (suite)

import Expect
import Json.Decode
import OpenApi.Server
import Test exposing (..)


suite : Test
suite =
    let
        decodedServer : Result Json.Decode.Error OpenApi.Server.Server
        decodedServer =
            Json.Decode.decodeString OpenApi.Server.decode example
    in
    describe "Decodes a server object"
        [ test "url" <|
            \() ->
                decodedServer
                    |> Result.map OpenApi.Server.url
                    |> Expect.equal (Ok "https://{username}.gigantic-server.com:{port}/{basePath}")
        , test "description" <|
            \() ->
                decodedServer
                    |> Result.map OpenApi.Server.description
                    |> Expect.equal (Ok (Just "The production API server"))
        , test "variables" <|
            \() ->
                decodedServer
                    |> Result.map OpenApi.Server.variables
                    |> Expect.ok
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
