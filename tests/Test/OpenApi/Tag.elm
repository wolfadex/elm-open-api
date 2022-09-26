module Test.OpenApi.Tag exposing (suite)

import Expect
import Json.Decode
import OpenApi.Tag
import Test exposing (..)


suite : Test
suite =
    let
        decodedTag : Result Json.Decode.Error OpenApi.Tag.Tag
        decodedTag =
            Json.Decode.decodeString OpenApi.Tag.decode example
    in
    describe "Decodes a tag object"
        [ test "name" <|
            \() ->
                decodedTag
                    |> Result.map OpenApi.Tag.name
                    |> Expect.equal (Ok "pet")
        , test "description" <|
            \() ->
                decodedTag
                    |> Result.map OpenApi.Tag.description
                    |> Expect.equal (Ok (Just "Pets operations"))
        , test "externalDocs" <|
            \() ->
                decodedTag
                    |> Result.map OpenApi.Tag.externalDocs
                    |> Expect.equal (Ok Nothing)
        ]


example : String
example =
    """{
\t"name": "pet",
\t"description": "Pets operations"
}"""
