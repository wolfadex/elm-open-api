module OpenApi.SecurityScheme exposing
    ( SecurityScheme
    , SecuritySchemeType(..)
    , SecuritySchemeIn(..)
    , decode
    , encode
    , description
    , type_
    )

{-| Corresponds to the [Security Scheme Object](https://spec.openapis.org/oas/latest.html#security-scheme-object) in the OpenAPI specification.


# Types

@docs SecurityScheme
@docs SecuritySchemeType
@docs SecuritySchemeIn


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs description
@docs type_

-}

import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Encode
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


{-| -}
encode : SecurityScheme -> Json.Encode.Value
encode (SecurityScheme securityScheme) =
    [ Internal.maybeEncodeField ( "description", Json.Encode.string ) securityScheme.description
    ]
        |> List.filterMap identity
        |> List.append (encodeType securityScheme.type_)
        |> Json.Encode.object


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


encodeType : SecuritySchemeType -> List ( String, Json.Encode.Value )
encodeType securitySchemeType =
    case securitySchemeType of
        ApiKey cfg ->
            encodeApiKey cfg

        Http cfg ->
            encodeHttp cfg

        MutualTls ->
            encodeMutualTls

        Oauth2 cfg ->
            encodeOauth2 cfg

        OpenIdConnect cfg ->
            encodeOpenIdConnect cfg


decodeApiKey : Decoder SecuritySchemeType
decodeApiKey =
    Json.Decode.map2
        (\name_ in__ ->
            ApiKey { name = name_, in_ = in__ }
        )
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "in" decodeSecuritySchemeIn)


encodeApiKey : { name : String, in_ : SecuritySchemeIn } -> List ( String, Json.Encode.Value )
encodeApiKey cfg =
    [ ( "type", Json.Encode.string "apiKey" )
    , ( "name", Json.Encode.string cfg.name )
    , ( "in", encodeSecuritySchemeIn cfg.in_ )
    ]


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


encodeSecuritySchemeIn : SecuritySchemeIn -> Json.Encode.Value
encodeSecuritySchemeIn securitySchemeIn =
    Json.Encode.string <|
        case securitySchemeIn of
            Query ->
                "query"

            Header ->
                "header"

            Cookie ->
                "cookie"


decodeHttp : Decoder SecuritySchemeType
decodeHttp =
    Json.Decode.map2
        (\scheme_ bearerFormat_ ->
            Http { scheme = scheme_, bearerFormat = bearerFormat_ }
        )
        (Json.Decode.field "scheme" Json.Decode.string)
        (Json.Decode.Extra.optionalField "bearerFormat" Json.Decode.string)


encodeHttp : { scheme : String, bearerFormat : Maybe String } -> List ( String, Json.Encode.Value )
encodeHttp cfg =
    List.filterMap identity
        [ Just ( "type", Json.Encode.string "http" )
        , Just ( "scheme", Json.Encode.string cfg.scheme )
        , Internal.maybeEncodeField ( "bearerFormat", Json.Encode.string ) cfg.bearerFormat
        ]


decodeMutualTls : Decoder SecuritySchemeType
decodeMutualTls =
    Json.Decode.succeed MutualTls


encodeMutualTls : List ( String, Json.Encode.Value )
encodeMutualTls =
    [ ( "type", Json.Encode.string "mutualTLS" ) ]


decodeOauth2 : Decoder SecuritySchemeType
decodeOauth2 =
    Json.Decode.map
        (\flows_ -> Oauth2 { flows = flows_ })
        (Json.Decode.field "flows" OpenApi.OauthFlow.decodeFlows)


encodeOauth2 : { flows : OauthFlows } -> List ( String, Json.Encode.Value )
encodeOauth2 cfg =
    [ ( "type", Json.Encode.string "oauth2" )
    , ( "flows", OpenApi.OauthFlow.encodeFlows cfg.flows )
    ]


decodeOpenIdConnect : Decoder SecuritySchemeType
decodeOpenIdConnect =
    Json.Decode.map
        (\openIdConnectUrl_ ->
            OpenIdConnect { openIdConnectUrl = openIdConnectUrl_ }
        )
        (Json.Decode.field "openIdConnectUrl" Json.Decode.string)


encodeOpenIdConnect : { openIdConnectUrl : String } -> List ( String, Json.Encode.Value )
encodeOpenIdConnect cfg =
    [ ( "type", Json.Encode.string "openIdConnect" )
    , ( "openIdConnectUrl", Json.Encode.string cfg.openIdConnectUrl )
    ]



-- Querying


{-| -}
type_ : SecurityScheme -> SecuritySchemeType
type_ (SecurityScheme securityScheme) =
    securityScheme.type_


{-| -}
description : SecurityScheme -> Maybe String
description (SecurityScheme securityScheme) =
    securityScheme.description
