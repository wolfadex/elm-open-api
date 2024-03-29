module OpenApi.RequestBody exposing
    ( RequestBody
    , decode
    , encode
    , content
    , description
    , required
    )

{-| Corresponds to the [RequestBody Object](https://spec.openapis.org/oas/latest#request-body-object) in the OpenAPI specification.


# Types

@docs RequestBody


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs content
@docs description
@docs required

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Encode
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
    OpenApi.Types.decodeRequestBody


{-| -}
encode : RequestBody -> Json.Encode.Value
encode =
    OpenApi.Types.encodeRequestBody



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
