module Test.OpenApi.SecurityRequirement exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.SecurityRequirement
import Test exposing (..)


suite : Test
suite =
    let
        decodedSecurityRequirement : Result Json.Decode.Error OpenApi.SecurityRequirement.SecurityRequirement
        decodedSecurityRequirement =
            Json.Decode.decodeString OpenApi.SecurityRequirement.decode example
    in
    describe "Decodes security requirements object"
        [ test "requirements" <|
            \() ->
                decodedSecurityRequirement
                    |> Result.map OpenApi.SecurityRequirement.requirements
                    |> Expect.equal (Ok (Dict.singleton "petstore_auth" [ "write:pets", "read:pets" ]))
        ]


example : String
example =
    """{
  "petstore_auth": [
    "write:pets",
    "read:pets"
  ]
}"""
