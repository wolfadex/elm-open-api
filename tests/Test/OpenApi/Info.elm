module Test.OpenApi.Info exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Decode
import OpenApi
import OpenApi.Info
import Test exposing (..)


suite : Test
suite =
    describe "Decodes the info object"
        [ test "Decodes the title" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0"
    }
}"""
                    |> Result.map (OpenApi.info >> OpenApi.Info.title)
                    |> Expect.equal (Ok "Valid OpenAPI")
        , test "Failes if the title is missing" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "info": {
        "version": "1.0.0"
    }
}"""
                    |> Expect.err
        , test "Failes if the version is missing" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "info": {
        "title": "Valid OpenAPI"
    }
}"""
                    |> Expect.err
        , test "Decodes a summary" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0",
        "summary": "A short summary"
    }
}"""
                    |> Result.map (OpenApi.info >> OpenApi.Info.summary)
                    |> Expect.equal (Ok (Just "A short summary"))
        , test "Decodes a description" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0",
        "description": "A short description"
    }
}"""
                    |> Result.map (OpenApi.info >> OpenApi.Info.description)
                    |> Expect.equal (Ok (Just "A short description"))
        , test "Decodes a termsOfService" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0",
        "termsOfService": "A short terms of service"
    }
}"""
                    |> Result.map (OpenApi.info >> OpenApi.Info.termsOfService)
                    |> Expect.equal (Ok (Just "A short terms of service"))
        ]
