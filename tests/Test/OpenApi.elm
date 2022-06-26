module Test.OpenApi exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Decode
import OpenApi
import Semver
import Test exposing (..)


suite : Test
suite =
    describe "Decodes any OpenAPI json string"
        [ test "Decodes the version" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0"
    }
}"""
                    |> Result.map (OpenApi.version >> Semver.print)
                    |> Expect.equal (Ok "3.0.0")
        , test "Failes if the version is missing" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0"
    }
}"""
                    |> Expect.err
        ]
