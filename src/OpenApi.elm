module OpenApi exposing
    ( decode
    , OpenApi, info, version
    )

{-| OpenAPI

@docs decode

-}

import Json.Decode exposing (Decoder)
import OpenApi.Info exposing (Info)
import Semver exposing (Version)


{-| -}
type OpenApi
    = OpenApi OpenApiInternal


type alias OpenApiInternal =
    { version : Version
    , info : Info
    }



-- Decoding


{-| Decodes valid OpenAPI JSON
-}
decode : Decoder OpenApi
decode =
    Json.Decode.map2
        (\version_ info_ ->
            OpenApi
                { version = version_
                , info = info_
                }
        )
        (Json.Decode.field "openapi" decodeVersion)
        (Json.Decode.field "info" OpenApi.Info.decode)


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


version : OpenApi -> Version
version (OpenApi openApi) =
    openApi.version


info : OpenApi -> Info
info (OpenApi openApi) =
    openApi.info
