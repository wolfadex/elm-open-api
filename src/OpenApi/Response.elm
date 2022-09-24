module OpenApi.Response exposing
    ( Response
    , content
    , decode
    , description
    , headers
    , links
    )

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import OpenApi.Link exposing (Link)
import OpenApi.MediaType exposing (MediaType)
import OpenApi.Types exposing (Header, ReferenceOr(..), Response(..))


type alias Response =
    OpenApi.Types.Response


decode : Decoder Response
decode =
    OpenApi.Types.decodeResponse


description : Response -> String
description (Response reference) =
    reference.description


headers : Response -> Dict String (ReferenceOr Header)
headers (Response reference) =
    reference.headers


content : Response -> Dict String MediaType
content (Response reference) =
    reference.content


links : Response -> Dict String (ReferenceOr Link)
links (Response reference) =
    reference.links
