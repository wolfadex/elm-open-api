module Test.OpenApi.License exposing (suite)

import Expect
import Json.Decode
import OpenApi.License
import Test exposing (..)


suite : Test
suite =
    describe "Decodes a license object"
        [ describe "with an identifier"
            (let
                decodedLicense : Result Json.Decode.Error OpenApi.License.License
                decodedLicense =
                    Json.Decode.decodeString OpenApi.License.decode exampleWithIdentifier
             in
             [ test "name" <|
                \() ->
                    decodedLicense
                        |> Result.map OpenApi.License.name
                        |> Expect.equal (Ok "Apache 2.0")
             , test "identifier" <|
                \() ->
                    decodedLicense
                        |> Result.map OpenApi.License.identifier
                        |> Expect.equal (Ok (Just "Apache-2.0"))
             , test "url" <|
                \() ->
                    decodedLicense
                        |> Result.map OpenApi.License.url
                        |> Expect.equal (Ok Nothing)
             ]
            )
        , describe "with a url"
            (let
                decodedLicense : Result Json.Decode.Error OpenApi.License.License
                decodedLicense =
                    Json.Decode.decodeString OpenApi.License.decode exampleWithUrl
             in
             [ test "name" <|
                \() ->
                    decodedLicense
                        |> Result.map OpenApi.License.name
                        |> Expect.equal (Ok "Apache 2.0")
             , test "identifier" <|
                \() ->
                    decodedLicense
                        |> Result.map OpenApi.License.identifier
                        |> Expect.equal (Ok Nothing)
             , test "url" <|
                \() ->
                    decodedLicense
                        |> Result.map OpenApi.License.url
                        |> Expect.equal (Ok (Just "https://www.apache.org/licenses/LICENSE-2.0.html"))
             ]
            )
        ]


exampleWithIdentifier : String
exampleWithIdentifier =
    """{
  "name": "Apache 2.0",
  "identifier": "Apache-2.0"
}"""


exampleWithUrl : String
exampleWithUrl =
    """{
  "name": "Apache 2.0",
  "url": "https://www.apache.org/licenses/LICENSE-2.0.html"
}"""
