module OpenApi.RequestBody exposing
    ( RequestBody
    , decode
    , content
    , description
    , required
    )

{-| Corresponds to the [RequestBody Object](https://spec.openapis.org/oas/latest.html#request-body-object) in the OpenAPI specification.


## Types

@docs RequestBody


## Decoding

@docs decode


## Querying

@docs content
@docs description
@docs required

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import OpenApi.MediaType exposing (MediaType)
import OpenApi.Types exposing (RequestBody(..))



-- Types


{-| -}
type alias RequestBody =
    OpenApi.Types.RequestBody



-- Decoding


{-| -}
decode : Decoder RequestBody
decode =
    Json.Decode.map3
        (\description_ content_ required_ ->
            RequestBody
                { description = description_
                , content = content_
                , required = required_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "content" (Json.Decode.dict OpenApi.MediaType.decode)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "required" Json.Decode.bool
            |> Json.Decode.map (Maybe.withDefault False)
        )



-- Querying


{-| -}
description : RequestBody -> Maybe String
description (RequestBody requestBody) =
    requestBody.description


{-| -}
content : RequestBody -> Dict String MediaType
content (RequestBody requestBody) =
    requestBody.content


{-| -}
required : RequestBody -> Bool
required (RequestBody requestBody) =
    requestBody.required
