module Test.OpenApi.Contact exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Decode
import OpenApi
import OpenApi.Contact
import OpenApi.Info
import Test exposing (..)


suite : Test
suite =
    describe "Decodes the contact object"
        [ test "Decodes a name" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0",
        "contact": {
            "name": "Wolfgang Schuster"
        }
    }
}"""
                    |> Result.map (OpenApi.info >> OpenApi.Info.contact >> Maybe.andThen OpenApi.Contact.name)
                    |> Expect.equal (Ok (Just "Wolfgang Schuster"))
        , test "Decodes a url" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0",
        "contact": {
            "url": "https://github.com/"
        }
    }
}"""
                    |> Result.map (OpenApi.info >> OpenApi.Info.contact >> Maybe.andThen OpenApi.Contact.url)
                    |> Expect.equal (Ok (Just "https://github.com/"))
        , test "Decodes an email" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """
{
    "openapi": "3.0.0",
    "info": {
        "title": "Valid OpenAPI",
        "version": "1.0.0",
        "contact": {
            "email": "carl@carl.carl"
        }
    }
}"""
                    |> Result.map (OpenApi.info >> OpenApi.Info.contact >> Maybe.andThen OpenApi.Contact.email)
                    |> Expect.equal (Ok (Just "carl@carl.carl"))
        ]
