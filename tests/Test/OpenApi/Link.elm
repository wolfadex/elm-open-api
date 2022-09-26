module Test.OpenApi.Link exposing (suite)

import Dict
import Expect
import Json.Decode
import OpenApi.Link
import Test exposing (..)


suite : Test
suite =
    describe "Decoding link objects"
        [ describe "with an operationId"
            (let
                decodedLink : Result Json.Decode.Error OpenApi.Link.Link
                decodedLink =
                    Json.Decode.decodeString OpenApi.Link.decode exampleWithOpId
             in
             [ test "server" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.server
                        |> Expect.equal (Ok Nothing)
             , test "requestBody" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.requestBody
                        |> Expect.equal (Ok Nothing)
             , test "parameters" <|
                \() ->
                    decodedLink
                        |> Result.map (OpenApi.Link.parameters >> Dict.size)
                        |> Expect.equal (Ok 1)
             , test "operationRef" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.operationRef
                        |> Expect.equal (Ok Nothing)
             , test "operationId" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.operationId
                        |> Expect.equal (Ok (Just "getUserAddressByUUID"))
             ]
            )
        , describe "with an operationRef"
            (let
                decodedLink : Result Json.Decode.Error OpenApi.Link.Link
                decodedLink =
                    Json.Decode.decodeString OpenApi.Link.decode exampleWithOpRef
             in
             [ test "server" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.server
                        |> Expect.equal (Ok Nothing)
             , test "requestBody" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.requestBody
                        |> Expect.equal (Ok Nothing)
             , test "parameters" <|
                \() ->
                    decodedLink
                        |> Result.map (OpenApi.Link.parameters >> Dict.size)
                        |> Expect.equal (Ok 1)
             , test "operationRef" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.operationRef
                        |> Expect.equal (Ok (Just "#/paths/~12.0~1repositories~1{username}/get"))
             , test "operationId" <|
                \() ->
                    decodedLink
                        |> Result.map OpenApi.Link.operationId
                        |> Expect.equal (Ok Nothing)
             ]
            )
        , test "with an operationRef and operationId" <|
            \() ->
                Json.Decode.decodeString OpenApi.Link.decode badExample
                    |> Expect.err
        ]



-- , operationId
-- , operationRef


exampleWithOpId : String
exampleWithOpId =
    """{
  "operationId": "getUserAddressByUUID",
  "parameters": {
    "userUuid": "$response.body#/uuid"
  }
}"""


exampleWithOpRef : String
exampleWithOpRef =
    """{
  "operationRef": "#/paths/~12.0~1repositories~1{username}/get",
  "parameters": {
    "userUuid": "$response.body#/username"
  }
}"""


badExample : String
badExample =
    """{
  "operationId": "getUserAddressByUUID",
  "operationRef": "#/paths/~12.0~1repositories~1{username}/get",
  "parameters": {
    "userUuid": "$response.body#/username"
  }
}"""
