module OpenApi.SecurityScheme exposing
    ( SecurityScheme
    , SecuritySchemeType(..)
    , decode
    , description
    , type_
    , SecuritySchemeIn(..)
    )

{-| Corresponds to the [Security Scheme Object](https://spec.openapis.org/oas/latest.html#security-scheme-object) in the OpenAPI specification.


## Types

@docs SecurityScheme
@docs SecuritySchemeType


## Decoding

@docs decode


## Querying

@docs description
@docs type_

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import OpenApi.OauthFlow exposing (OauthFlows)



-- Types


{-| -}
type SecurityScheme
    = SecurityScheme Internal


type alias Internal =
    { type_ : SecuritySchemeType
    , description : Maybe String
    }


{-| -}
type SecuritySchemeType
    = ApiKey { name : String, in_ : SecuritySchemeIn }
    | Http { scheme : String, bearerFormat : Maybe String }
    | MutualTls
    | Oauth2 { flows : OauthFlows }
    | OpenIdConnect { openIdConnectUrl : String }


{-| -}
type SecuritySchemeIn
    = Query
    | Header
    | Cookie



-- Decoding


{-| -}
decode : Decoder SecurityScheme
decode =
    Json.Decode.map2
        (\type__ description_ ->
            SecurityScheme
                { type_ = type__
                , description = description_
                }
        )
        decodeType
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)


decodeType : Decoder SecuritySchemeType
decodeType =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\typeStr ->
                case typeStr of
                    "apiKey" ->
                        decodeApiKey

                    "http" ->
                        decodeHttp

                    "mutualTLS" ->
                        decodeMutualTls

                    "oauth2" ->
                        decodeOauth2

                    "openIdConnect" ->
                        decodeOpenIdConnect

                    _ ->
                        Json.Decode.fail ("Unknown Security Scheme type: " ++ typeStr)
            )


decodeApiKey : Decoder SecuritySchemeType
decodeApiKey =
    Json.Decode.map2
        (\name_ in__ ->
            ApiKey { name = name_, in_ = in__ }
        )
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "in" decodeSecuritySchemeIn)


decodeSecuritySchemeIn : Decoder SecuritySchemeIn
decodeSecuritySchemeIn =
    Json.Decode.string
        |> Json.Decode.andThen
            (\inStr ->
                case inStr of
                    "query" ->
                        Json.Decode.succeed Query

                    "header" ->
                        Json.Decode.succeed Header

                    "cookie" ->
                        Json.Decode.succeed Cookie

                    _ ->
                        Json.Decode.fail ("Unkown Security Scheme apikey in value: " ++ inStr)
            )


decodeHttp : Decoder SecuritySchemeType
decodeHttp =
    Json.Decode.map2
        (\scheme_ bearerFormat_ ->
            Http { scheme = scheme_, bearerFormat = bearerFormat_ }
        )
        (Json.Decode.field "scheme" Json.Decode.string)
        (Json.Decode.Extra.optionalField "bearerFormat" Json.Decode.string)


decodeMutualTls : Decoder SecuritySchemeType
decodeMutualTls =
    Json.Decode.succeed MutualTls


decodeOauth2 : Decoder SecuritySchemeType
decodeOauth2 =
    Json.Decode.map
        (\flows_ -> Oauth2 { flows = flows_ })
        (Json.Decode.field "flows" OpenApi.OauthFlow.decodeFlows)


decodeOpenIdConnect : Decoder SecuritySchemeType
decodeOpenIdConnect =
    Json.Decode.map
        (\openIdConnectUrl_ ->
            OpenIdConnect { openIdConnectUrl = openIdConnectUrl_ }
        )
        (Json.Decode.field "openIdConnectUrl" Json.Decode.string)



-- Querying


{-| -}
type_ : SecurityScheme -> SecuritySchemeType
type_ (SecurityScheme securityScheme) =
    securityScheme.type_


{-| -}
description : SecurityScheme -> Maybe String
description (SecurityScheme securityScheme) =
    securityScheme.description
