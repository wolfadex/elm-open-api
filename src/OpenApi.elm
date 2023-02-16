module OpenApi exposing
    ( OpenApi
    , decode
    , components
    , externalDocs
    , info
    , jsonSchemaDialect
    , paths
    , servers
    , tags
    , version
    )

{-| Corresponds to the [OpenAPI Object](https://spec.openapis.org/oas/latest#openapi-object) in the OpenAPI specification.


# Types

@docs OpenApi


# Decoding

@docs decode


# Querying

@docs components
@docs externalDocs
@docs info
@docs jsonSchemaDialect
@docs paths
@docs servers
@docs tags
@docs version

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline
import OpenApi.Components exposing (Components)
import OpenApi.ExternalDocumentation exposing (ExternalDocumentation)
import OpenApi.Info exposing (Info)
import OpenApi.Server
import OpenApi.Tag exposing (Tag)
import OpenApi.Types exposing (Path, ReferenceOr, SecurityRequirement, Server)
import Semver exposing (Version)


{-| An OpenAPI Specification (OAS)
-}
type OpenApi
    = OpenApi Internal


type alias Internal =
    { version : Version
    , info : Info
    , jsonSchemaDialect : Maybe String
    , servers : List Server
    , paths : Dict String Path
    , webhooks : Dict String (ReferenceOr Path)
    , components : Maybe Components
    , security : List SecurityRequirement
    , tags : List Tag
    , externalDocs : Maybe ExternalDocumentation
    }



-- Decoding


{-| Decodes valid OpenAPI JSON v3.1
-}
decode : Decoder OpenApi
decode =
    Json.Decode.succeed
        (\version_ info_ jsonSchemaDialect_ externalDocs_ tags_ servers_ components_ paths_ security_ webhooks_ ->
            OpenApi
                { version = version_
                , info = info_
                , jsonSchemaDialect = jsonSchemaDialect_
                , servers = servers_
                , paths = paths_
                , webhooks = webhooks_
                , components = components_
                , security = security_
                , tags = tags_
                , externalDocs = externalDocs_
                }
        )
        |> Json.Decode.Pipeline.required "openapi" decodeVersion
        |> Json.Decode.Pipeline.required "info" OpenApi.Info.decode
        |> OpenApi.Types.optionalNothing "jsonSchemaDialect" Json.Decode.string
        |> OpenApi.Types.optionalNothing "externalDocs" OpenApi.ExternalDocumentation.decode
        |> Json.Decode.Pipeline.optional "tags" (Json.Decode.list OpenApi.Tag.decode) []
        |> Json.Decode.Pipeline.optional "servers" (Json.Decode.list OpenApi.Server.decode) []
        |> OpenApi.Types.optionalNothing "components" OpenApi.Components.decode
        |> Json.Decode.Pipeline.optional "paths" (Json.Decode.dict OpenApi.Types.decodePath) Dict.empty
        |> Json.Decode.Pipeline.optional "security" (Json.Decode.list OpenApi.Types.decodeSecurityRequirement) []
        |> Json.Decode.Pipeline.optional "webhooks" (Json.Decode.dict (OpenApi.Types.decodeRefOr OpenApi.Types.decodePath)) Dict.empty


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


{-| -}
paths : OpenApi -> Dict String Path
paths (OpenApi openApi) =
    openApi.paths
