module OpenApi.Contact exposing
    ( Contact
    , decode
    , encode
    , email
    , name
    , url
    )

{-| Corresponds to the [Contact Object](https://spec.openapis.org/oas/latest#contact-object) in the OpenAPI specification.


# Types

@docs Contact


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs email
@docs name
@docs url

-}

import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Encode



-- Types


{-| -}
type Contact
    = Contact Internal


type alias Internal =
    { name : Maybe String
    , url : Maybe String
    , email : Maybe String
    }



-- Decoding


{-| -}
decode : Decoder Contact
decode =
    Json.Decode.map3
        (\name_ url_ email_ ->
            Contact
                { name = name_
                , url = url_
                , email = email_
                }
        )
        (Json.Decode.Extra.optionalField "name" Json.Decode.string)
        (Json.Decode.Extra.optionalField "url" Json.Decode.string)
        (Json.Decode.Extra.optionalField "email" Json.Decode.string)


{-| -}
encode : Contact -> Json.Encode.Value
encode (Contact contact) =
    [ Internal.maybeEncodeField ( "name", Json.Encode.string ) contact.name
    , Internal.maybeEncodeField ( "url", Json.Encode.string ) contact.url
    , Internal.maybeEncodeField ( "email", Json.Encode.string ) contact.email
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- Querying


{-| -}
name : Contact -> Maybe String
name (Contact contact) =
    contact.name


{-| -}
url : Contact -> Maybe String
url (Contact contact) =
    contact.url


{-| -}
email : Contact -> Maybe String
email (Contact contact) =
    contact.email
