module OpenApi.Contact exposing
    ( Contact
    , decode
    , email
    , name
    , url
    )

{-| Corresponds to the [Contact Object](https://spec.openapis.org/oas/latest#contact-object) in the OpenAPI specification.


# Types

@docs Contact


# Decoding

@docs decode


# Querying

@docs email
@docs name
@docs url

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Extra



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
