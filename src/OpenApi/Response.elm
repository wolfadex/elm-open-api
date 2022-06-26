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
import Json.Decode.Extra
import OpenApi.Header exposing (Header)
import OpenApi.MediaType exposing (MediaType)
import OpenApi.Reference exposing (ReferenceOr(..))


type Response
    = Response Internal


type alias Internal =
    { description : String
    , headers : Dict String (ReferenceOr Header)
    , content : Dict String MediaType
    , links : Dict String (ReferenceOr ())
    }


decode : Decoder Response
decode =
    Json.Decode.map4
        (\description_ headers_ content_ links_ ->
            Response
                { description = description_
                , headers = headers_
                , content = content_
                , links = links_
                }
        )
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "headers"
            (Json.Decode.dict (OpenApi.Reference.decodeOr OpenApi.Header.decode))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "content"
            (Json.Decode.dict OpenApi.MediaType.decode)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "links"
            (Json.Decode.dict (OpenApi.Reference.decodeOr (Debug.todo "")))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )


description : Response -> String
description (Response reference) =
    reference.description


headers : Response -> Dict String (ReferenceOr Header)
headers (Response reference) =
    reference.headers


content : Response -> Dict String MediaType
content (Response reference) =
    reference.content


links : Response -> Dict String (ReferenceOr ())
links (Response reference) =
    reference.links
