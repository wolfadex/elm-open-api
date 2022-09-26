module Test.OpenApi.Reference exposing (suite)

import Expect
import Json.Decode
import OpenApi.Reference
import Test exposing (..)


suite : Test
suite =
    let
        decodedReference : Result Json.Decode.Error OpenApi.Reference.Reference
        decodedReference =
            Json.Decode.decodeString OpenApi.Reference.decode example
    in
    describe "Decodes a reference object"
        [ test "summary" <|
            \() ->
                decodedReference
                    |> Result.map OpenApi.Reference.summary
                    |> Expect.equal (Ok Nothing)
        , test "description" <|
            \() ->
                decodedReference
                    |> Result.map OpenApi.Reference.description
                    |> Expect.equal (Ok Nothing)
        , test "ref" <|
            \() ->
                decodedReference
                    |> Result.map OpenApi.Reference.ref
                    |> Expect.equal (Ok "#/components/schemas/Pet")
        ]


example : String
example =
    """{
  "$ref": "#/components/schemas/Pet"
}"""
