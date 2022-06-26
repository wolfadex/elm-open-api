module OpenApi.Info exposing (..)

import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import OpenApi.Contact exposing (Contact)
import OpenApi.License exposing (License)


type Info
    = Info InfoInternal


type alias InfoInternal =
    { title : String
    , summary : Maybe String
    , description : Maybe String
    , termsOfService : Maybe String
    , contact : Maybe Contact
    , license : Maybe License
    , version : String
    }


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


title : Info -> String
title (Info info) =
    info.title


summary : Info -> Maybe String
summary (Info info) =
    info.summary


description : Info -> Maybe String
description (Info info) =
    info.description


termsOfService : Info -> Maybe String
termsOfService (Info info) =
    info.termsOfService


contact : Info -> Maybe Contact
contact (Info info) =
    info.contact


license : Info -> Maybe License
license (Info info) =
    info.license


version : Info -> String
version (Info info) =
    info.version
