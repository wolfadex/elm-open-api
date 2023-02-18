module OpenApi.Info exposing
    ( Info
    , decode
    , encode
    , contact
    , description
    , license
    , summary
    , termsOfService
    , title
    , version
    )

{-| Corresponds to the [Info Object](https://spec.openapis.org/oas/latest.html#info-object) in the OpenAPI specification.


# Types

@docs Info


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs contact
@docs description
@docs license
@docs summary
@docs termsOfService
@docs title
@docs version

-}

import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Encode
import OpenApi.Contact exposing (Contact)
import OpenApi.License exposing (License)



-- Types


{-| -}
type Info
    = Info Internal


type alias Internal =
    { title : String
    , summary : Maybe String
    , description : Maybe String
    , termsOfService : Maybe String
    , contact : Maybe Contact
    , license : Maybe License
    , version : String
    }



-- Decoding


{-| -}
decode : Decoder Info
decode =
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
        (Json.Decode.Extra.optionalField "summary" Json.Decode.string)
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "termsOfService" Json.Decode.string)
        (Json.Decode.Extra.optionalField "contact" OpenApi.Contact.decode)
        (Json.Decode.Extra.optionalField "license" OpenApi.License.decode)
        (Json.Decode.field "version" Json.Decode.string)


{-| -}
encode : Info -> Json.Encode.Value
encode (Info info) =
    [ Just ( "title", Json.Encode.string info.title )
    , Internal.maybeEncodeField ( "summary", Json.Encode.string ) info.summary
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) info.description
    , Internal.maybeEncodeField ( "termsOfService", Json.Encode.string ) info.termsOfService
    , Internal.maybeEncodeField ( "contact", OpenApi.Contact.encode ) info.contact
    , Internal.maybeEncodeField ( "license", OpenApi.License.encode ) info.license
    , Just ( "version", Json.Encode.string info.version )
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- Querying


{-| -}
title : Info -> String
title (Info info) =
    info.title


{-| -}
summary : Info -> Maybe String
summary (Info info) =
    info.summary


{-| -}
description : Info -> Maybe String
description (Info info) =
    info.description


{-| -}
termsOfService : Info -> Maybe String
termsOfService (Info info) =
    info.termsOfService


{-| -}
contact : Info -> Maybe Contact
contact (Info info) =
    info.contact


{-| -}
license : Info -> Maybe License
license (Info info) =
    info.license


{-| -}
version : Info -> String
version (Info info) =
    info.version
