module OpenApi.Contact exposing (..)

import Json.Decode exposing (Decoder)
import Json.Decode.Extra


type Contact
    = Contact ContactInternal


type alias ContactInternal =
    { name : Maybe String
    , url : Maybe String
    , email : Maybe String
    }


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


name : Contact -> Maybe String
name (Contact contact) =
    contact.name


url : Contact -> Maybe String
url (Contact contact) =
    contact.url


email : Contact -> Maybe String
email (Contact contact) =
    contact.email
