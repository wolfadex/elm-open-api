module OpenApi exposing
    ( decode
    , Info, OpenApi, info, version
    )

{-| OpenAPI

@docs decode

-}

import Html exposing (summary)
import Json.Decode exposing (Decoder)
import Semver exposing (Version)


{-| -}
type OpenApi
    = OpenApi OpenApiInternal


type alias OpenApiInternal =
    { version : Version
    , info : Info
    }


type Info
    = Info InfoInternal


type alias InfoInternal =
    { title : String
    , summary : Maybe String
    , description : Maybe String
    , termsOfService : Maybe String
    , contact : Maybe String
    , license : Maybe String
    , version : String
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
        (Json.Decode.field "info" decodeInfo)


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


decodeInfo : Decoder Info
decodeInfo =
    Json.Decode.map7
        (\title_ summary_ description_ termsOfService_ contact_ license_ version_ ->
            Info
                { title = title_
                , summary = summary_
                , description = description_
                , termsOfService = termsOfService_
                , contact = contact_
                , license = license_
                , version = version_
                }
        )
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.maybe (Json.Decode.field "summary" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "description" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "termsOfService" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "contact" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "license" Json.Decode.string))
        (Json.Decode.field "version" Json.Decode.string)



-- Querying


version : OpenApi -> Version
version (OpenApi openApi) =
    openApi.version


info : OpenApi -> Info
info (OpenApi openApi) =
    openApi.info
