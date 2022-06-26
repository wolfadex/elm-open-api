module OpenApi exposing
    ( OpenApi
    , decode
    , components
    , externalDocs
    , info
    , jsonSchemaDialect
    , servers
    , tags
    , version
    )

{-| Corresponds to the [OpenAPI Object](https://spec.openapis.org/oas/latest.html#openapi-object) in the OpenAPI specification.


## Types

@docs OpenApi


## Decoding

@docs decode


## Querying

@docs components
@docs externalDocs
@docs info
@docs jsonSchemaDialect
@docs servers
@docs tags
@docs version

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import OpenApi.Components exposing (Components)
import OpenApi.ExternalDocumentation exposing (ExternalDocumentation)
import OpenApi.Info exposing (Info)
import OpenApi.Server exposing (Server)
import OpenApi.Tag exposing (Tag)
import Semver exposing (Version)


{-| -}
type OpenApi
    = OpenApi Internal


type alias Internal =
    { version : Version
    , info : Info
    , jsonSchemaDialect : Maybe String
    , externalDocs : Maybe ExternalDocumentation
    , tags : List Tag
    , servers : List Server
    , components : Maybe Components
    }



-- Decoding


{-| Decodes valid OpenAPI JSON
-}
decode : Decoder OpenApi
decode =
    Json.Decode.map7
        (\version_ info_ jsonSchemaDialect_ externalDocs_ tags_ servers_ components_ ->
            OpenApi
                { version = version_
                , info = info_
                , jsonSchemaDialect = jsonSchemaDialect_
                , externalDocs = externalDocs_
                , tags = tags_
                , servers = servers_
                , components = components_
                }
        )
        (Json.Decode.field "openapi" decodeVersion)
        (Json.Decode.field "info" OpenApi.Info.decode)
        (Json.Decode.Extra.optionalField "jsonSchemaDialect" Json.Decode.string)
        (Json.Decode.Extra.optionalField "externalDocs" OpenApi.ExternalDocumentation.decode)
        (Json.Decode.Extra.optionalField "tags" (Json.Decode.list OpenApi.Tag.decode)
            |> Json.Decode.map (Maybe.withDefault [])
        )
        (Json.Decode.Extra.optionalField "servers" (Json.Decode.list OpenApi.Server.decode)
            |> Json.Decode.map (Maybe.withDefault [])
        )
        (Json.Decode.Extra.optionalField "components" OpenApi.Components.decode)


decodeVersion : Decoder Version
decodeVersion =
    Json.Decode.string
        |> Json.Decode.andThen
            (\str ->
                case Semver.parse str of
                    Nothing ->
                        Json.Decode.fail "Invalid version format"

                    Just version_ ->
                        Json.Decode.succeed version_
            )



-- Querying


{-| -}
version : OpenApi -> Version
version (OpenApi openApi) =
    openApi.version


{-| -}
info : OpenApi -> Info
info (OpenApi openApi) =
    openApi.info


{-| -}
jsonSchemaDialect : OpenApi -> Maybe String
jsonSchemaDialect (OpenApi openApi) =
    openApi.jsonSchemaDialect


{-| -}
externalDocs : OpenApi -> Maybe ExternalDocumentation
externalDocs (OpenApi openApi) =
    openApi.externalDocs


{-| -}
tags : OpenApi -> List Tag
tags (OpenApi openApi) =
    openApi.tags


{-| -}
servers : OpenApi -> List Server
servers (OpenApi openApi) =
    openApi.servers


{-| -}
components : OpenApi -> Maybe Components
components (OpenApi openApi) =
    openApi.components
