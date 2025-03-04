module OpenApi.Operation exposing
    ( Operation
    , decode
    , encode
    , callbacks
    , deprecated
    , description
    , externalDocs
    , operationId
    , parameters
    , requestBody
    , responses
    , security
    , servers
    , summary
    , tags
    )

{-| Corresponds to the [Operation Object](https://spec.openapis.org/oas/latest#operation-object) in the OpenAPI specification.


# Types

@docs Operation


# Decoding / Encoding

@docs decode
@docs encode


## Querying

@docs callbacks
@docs deprecated
@docs description
@docs externalDocs
@docs operationId
@docs parameters
@docs requestBody
@docs responses
@docs security
@docs servers
@docs summary
@docs tags

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.ExternalDocumentation exposing (ExternalDocumentation)
import OpenApi.Reference exposing (ReferenceOr)
import OpenApi.RequestBody exposing (RequestBody)
import OpenApi.Response exposing (Response)
import OpenApi.Server exposing (Server)
import OpenApi.Types exposing (Callback, Operation(..), Parameter, SecurityRequirement)


{-| -}
type alias Operation =
    OpenApi.Types.Operation


{-| -}
decode : Decoder Operation
decode =
    OpenApi.Types.decodeOperation


{-| -}
encode : Operation -> Json.Encode.Value
encode =
    OpenApi.Types.encodeOperation


{-| -}
tags : Operation -> List String
tags (Operation operation_) =
    operation_.tags


{-| -}
summary : Operation -> Maybe String
summary (Operation operation_) =
    operation_.summary


{-| -}
description : Operation -> Maybe String
description (Operation operation_) =
    operation_.description


{-| -}
externalDocs : Operation -> Maybe ExternalDocumentation
externalDocs (Operation operation_) =
    operation_.externalDocs


{-| -}
operationId : Operation -> Maybe String
operationId (Operation operation_) =
    operation_.operationId


{-| -}
parameters : Operation -> List (ReferenceOr Parameter)
parameters (Operation operation_) =
    operation_.parameters


{-| -}
requestBody : Operation -> Maybe (ReferenceOr RequestBody)
requestBody (Operation operation_) =
    operation_.requestBody


{-| -}
responses : Operation -> Dict String (ReferenceOr Response)
responses (Operation operation_) =
    operation_.responses


{-| -}
callbacks : Operation -> Dict String (ReferenceOr Callback)
callbacks (Operation operation_) =
    operation_.callbacks


{-| -}
deprecated : Operation -> Bool
deprecated (Operation operation_) =
    operation_.deprecated


{-| SecurityRequirements the operation specifies (possibly an empty list), or Nothing if the operation does not specify any.

If an operation specifies `security`, the given value (even if it's an empty array) overrides the schema's top-level `security`. This is documented in the OpenAPI specification here: <https://swagger.io/specification/v3/#operation-object>.

-}
security : Operation -> Maybe (List SecurityRequirement)
security (Operation operation_) =
    operation_.security


{-| -}
servers : Operation -> List Server
servers (Operation operation_) =
    operation_.servers
