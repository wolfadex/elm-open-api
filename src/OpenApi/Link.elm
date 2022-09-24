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
import Json.Decode exposing (Decoder, Value)
import OpenApi.Types exposing (Link(..), LinkRefOrId(..), Server)



-- Types


{-| -}
type alias Link =
    OpenApi.Types.Link



-- Decoding


{-| -}
decode : Decoder Link
decode =
    OpenApi.Types.decodeLink



-- Querying


{-| -}
operationRef : Link -> Maybe String
operationRef (Link link) =
    case link.operationRefOrId of
        Just (LinkRef ref) ->
            Just ref

        _ ->
            Nothing


{-| -}
operationId : Link -> Maybe String
operationId (Link link) =
    case link.operationRefOrId of
        Just (LinkId id) ->
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
