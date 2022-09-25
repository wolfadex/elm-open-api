module Test.OpenApi.Info exposing (suite)

import Expect
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
        , describe "complete example"
            (let
                decodedInfo : Result Json.Decode.Error OpenApi.Info.Info
                decodedInfo =
                    Json.Decode.decodeString OpenApi.Info.decode example
             in
             [ test "title" <|
                \() ->
                    decodedInfo
                        |> Result.map OpenApi.Info.title
                        |> Expect.equal (Ok "Sample Pet Store App")
             , test "summary" <|
                \() ->
                    decodedInfo
                        |> Result.map OpenApi.Info.summary
                        |> Expect.equal (Ok (Just "A pet store manager."))
             , test "description" <|
                \() ->
                    decodedInfo
                        |> Result.map OpenApi.Info.description
                        |> Expect.equal (Ok (Just "This is a sample server for a pet store."))
             , test "termsOfService" <|
                \() ->
                    decodedInfo
                        |> Result.map OpenApi.Info.termsOfService
                        |> Expect.equal (Ok (Just "https://example.com/terms/"))
             , test "version" <|
                \() ->
                    decodedInfo
                        |> Result.map OpenApi.Info.version
                        |> Expect.equal (Ok "1.0.1")
             , test "contact" <|
                \() ->
                    decodedInfo
                        |> Result.map OpenApi.Info.contact
                        |> Expect.ok
             , test "license" <|
                \() ->
                    decodedInfo
                        |> Result.map OpenApi.Info.license
                        |> Expect.ok
             ]
            )
        ]


example : String
example =
    """{
  "title": "Sample Pet Store App",
  "summary": "A pet store manager.",
  "description": "This is a sample server for a pet store.",
  "termsOfService": "https://example.com/terms/",
  "contact": {
    "name": "API Support",
    "url": "https://www.example.com/support",
    "email": "support@example.com"
  },
  "license": {
    "name": "Apache 2.0",
    "url": "https://www.apache.org/licenses/LICENSE-2.0.html"
  },
  "version": "1.0.1"
}"""
