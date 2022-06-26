module OpenApi exposing
    ( OpenApi
    , decode
    , externalDocs
    , info
    , jsonSchemaDialect
    , version
    )

{-| OpenAPI


## Types

@docs OpenApi


## Decoding

@docs decode


## Querying

@docs externalDocs
@docs info
@docs jsonSchemaDialect
@docs version

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import OpenApi.ExternalDocumentation exposing (ExternalDocumentation)
import OpenApi.Info exposing (Info)
import Semver exposing (Version)


{-| -}
type OpenApi
    = OpenApi OpenApiInternal


type alias OpenApiInternal =
    { version : Version
    , info : Info
    , jsonSchemaDialect : Maybe String
    , externalDocs : Maybe ExternalDocumentation
    }



-- Decoding


{-| Decodes valid OpenAPI JSON
-}
decode : Decoder OpenApi
decode =
    Json.Decode.map4
        (\version_ info_ jsonSchemaDialect_ externalDocs_ ->
            OpenApi
                { version = version_
                , info = info_
                , jsonSchemaDialect = jsonSchemaDialect_
                , externalDocs = externalDocs_
                }
        )
        (Json.Decode.field "openapi" decodeVersion)
        (Json.Decode.field "info" OpenApi.Info.decode)
        (Json.Decode.Extra.optionalField "jsonSchemaDialect" Json.Decode.string)
        (Json.Decode.Extra.optionalField "externalDocs" OpenApi.ExternalDocumentation.decode)


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
