module OpenApi.Link exposing
    ( Link
    , decode
    , description
    , operationId
    , operationRef
    , parameters
    , requestBody
    , server
    )

{-| Corresponds to the [Link Object](https://spec.openapis.org/oas/latest.html#link-object) in the OpenAPI specification.


## Types

@docs Link


## Decoding

@docs decode


## Querying

@docs description
@docs operationId
@docs operationRef
@docs parameters
@docs requestBody
@docs server

-}

import Dict exposing (Dict)
import Internal
import Json.Decode exposing (Decoder, Value)
import Json.Decode.Extra
import OpenApi.Server exposing (Server)



-- Types


{-| -}
type Link
    = Link Internal


type alias Internal =
    { operationRefOrId : Maybe RefOrId
    , parameters : Dict String Value
    , requestBody : Maybe Value
    , description : Maybe String
    , server : Maybe Server
    }


type RefOrId
    = Ref String
    | Id String



-- Decoding


{-| -}
decode : Decoder Link
decode =
    Json.Decode.map5
        (\operationRefOrId_ parameters_ requestBody_ description_ server_ ->
            Link
                { operationRefOrId = operationRefOrId_
                , parameters = parameters_
                , requestBody = requestBody_
                , description = description_
                , server = server_
                }
        )
        decodeRefOrId
        (Json.Decode.Extra.optionalField "parameters" (Json.Decode.dict Json.Decode.value)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "requestBody" Json.Decode.value)
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "server" OpenApi.Server.decode)


decodeRefOrId : Decoder (Maybe RefOrId)
decodeRefOrId =
    Internal.andThen2
        (\operationRef_ operationId_ ->
            case ( operationRef_, operationId_ ) of
                ( Nothing, Nothing ) ->
                    Json.Decode.succeed Nothing

                ( Just ref, Nothing ) ->
                    Json.Decode.succeed (Just (Ref ref))

                ( Nothing, Just id ) ->
                    Json.Decode.succeed (Just (Id id))

                ( Just _, Just _ ) ->
                    Json.Decode.fail "A Link Object cannot have both an operationRef and an operationId, but I found both."
        )
        (Json.Decode.Extra.optionalField "operationRef" Json.Decode.string)
        (Json.Decode.Extra.optionalField "operationId" Json.Decode.string)



-- Querying


{-| -}
operationRef : Link -> Maybe String
operationRef (Link link) =
    case link.operationRefOrId of
        Just (Ref ref) ->
            Just ref

        _ ->
            Nothing


{-| -}
operationId : Link -> Maybe String
operationId (Link link) =
    case link.operationRefOrId of
        Just (Id id) ->
            Just id

        _ ->
            Nothing


{-| -}
parameters : Link -> Dict String Value
parameters (Link link) =
    link.parameters


{-| -}
requestBody : Link -> Maybe Value
requestBody (Link link) =
    link.requestBody


{-| -}
description : Link -> Maybe String
description (Link link) =
    link.description


{-| -}
server : Link -> Maybe Server
server (Link link) =
    link.server
