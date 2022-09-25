module Test.OpenApi.ExternalDocumentation exposing (suite)

import Expect
import Json.Decode
import OpenApi.ExternalDocumentation
import Test exposing (..)


suite : Test
suite =
    let
        decodedExternalDocumentation : Result Json.Decode.Error OpenApi.ExternalDocumentation.ExternalDocumentation
        decodedExternalDocumentation =
            Json.Decode.decodeString OpenApi.ExternalDocumentation.decode example
    in
    describe "Decodes external documentation object"
        [ test "url" <|
            \() ->
                decodedExternalDocumentation
                    |> Result.map OpenApi.ExternalDocumentation.url
                    |> Expect.equal (Ok "https://example.com")
        , test "description" <|
            \() ->
                decodedExternalDocumentation
                    |> Result.map OpenApi.ExternalDocumentation.description
                    |> Expect.equal (Ok (Just "Find more info here"))
        ]


example : String
example =
    """{
  "description": "Find more info here",
  "url": "https://example.com"
}"""
