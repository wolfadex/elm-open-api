module OpenApi.Components exposing
    ( Components
    , decode
    , encode
    , callbacks
    , examples
    , headers
    , links
    , parameters
    , pathItems
    , requestBodies
    , responses
    , schemas
    , securitySchemes
    )

{-| Corresponds to the [Components Object](https://spec.openapis.org/oas/latest.html#components-object) in the OpenAPI specification.


# Types

@docs Components


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs callbacks
@docs examples
@docs headers
@docs links
@docs parameters
@docs pathItems
@docs requestBodies
@docs responses
@docs schemas
@docs securitySchemes

-}

import Dict exposing (Dict)
import Internal
import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.SecurityScheme exposing (SecurityScheme)
import OpenApi.Types
    exposing
        ( Callback
        , Example
        , Header
        , Link
        , Parameter
        , Path
        , ReferenceOr(..)
        , RequestBody(..)
        , Response
        , Schema
        )



-- Types


{-| -}
type Components
    = Components Internal


type alias Internal =
    { schemas : Dict String Schema
    , responses : Dict String (ReferenceOr Response)
    , parameters : Dict String (ReferenceOr Parameter)
    , examples : Dict String (ReferenceOr Example)
    , requestBodies : Dict String (ReferenceOr RequestBody)
    , headers : Dict String (ReferenceOr Header)
    , securitySchemes : Dict String (ReferenceOr SecurityScheme)
    , links : Dict String (ReferenceOr Link)
    , callbacks : Dict String (ReferenceOr Callback)
    , pathItems : Dict String (ReferenceOr Path)
    }



-- Decoding


{-| -}
decode : Decoder Components
decode =
    Json.Decode.succeed
        (\schemas_ responses_ parameters_ examples_ requestBodies_ headers_ securitySchemes_ links_ callbacks_ pathItems_ ->
            Components
                { schemas = schemas_
                , responses = responses_
                , parameters = parameters_
                , examples = examples_
                , requestBodies = requestBodies_
                , headers = headers_
                , securitySchemes = securitySchemes_
                , links = links_
                , callbacks = callbacks_
                , pathItems = pathItems_
                }
        )
        |> OpenApi.Types.decodeOptionalDict "schemas" OpenApi.Types.decodeSchema
        |> OpenApi.Types.decodeOptionalDict "responses" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeResponse)
        |> OpenApi.Types.decodeOptionalDict "parameters" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeParameter)
        |> OpenApi.Types.decodeOptionalDict "examples" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeExample)
        |> OpenApi.Types.decodeOptionalDict "requestBodies" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeRequestBody)
        |> OpenApi.Types.decodeOptionalDict "headers" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeHeader)
        |> OpenApi.Types.decodeOptionalDict "securitySchemes" (OpenApi.Types.decodeRefOr OpenApi.SecurityScheme.decode)
        |> OpenApi.Types.decodeOptionalDict "links" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeLink)
        |> OpenApi.Types.decodeOptionalDict "callbacks" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeCallback)
        |> OpenApi.Types.decodeOptionalDict "pathItems" (OpenApi.Types.decodeRefOr OpenApi.Types.decodePath)


{-| -}
encode : Components -> Json.Encode.Value
encode (Components components) =
    [ Internal.maybeEncodeDictField ( "schemas", identity, OpenApi.Types.encodeSchema ) components.schemas
    , Internal.maybeEncodeDictField ( "responses", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodeResponse ) components.responses
    , Internal.maybeEncodeDictField ( "parameters", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodeParameter ) components.parameters
    , Internal.maybeEncodeDictField ( "examples", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodeExample ) components.examples
    , Internal.maybeEncodeDictField ( "requestBodies", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodeRequestBody ) components.requestBodies
    , Internal.maybeEncodeDictField ( "headers", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodeHeader ) components.headers
    , Internal.maybeEncodeDictField ( "securitySchemes", identity, OpenApi.Types.encodeRefOr OpenApi.SecurityScheme.encode ) components.securitySchemes
    , Internal.maybeEncodeDictField ( "links", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodeLink ) components.links
    , Internal.maybeEncodeDictField ( "callbacks", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodeCallback ) components.callbacks
    , Internal.maybeEncodeDictField ( "pathItems", identity, OpenApi.Types.encodeRefOr OpenApi.Types.encodePath ) components.pathItems
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- Querying


{-| -}
schemas : Components -> Dict String Schema
schemas (Components contact) =
    contact.schemas


{-| -}
responses : Components -> Dict String (ReferenceOr Response)
responses (Components contact) =
    contact.responses


{-| -}
parameters : Components -> Dict String (ReferenceOr Parameter)
parameters (Components contact) =
    contact.parameters


{-| -}
examples : Components -> Dict String (ReferenceOr Example)
examples (Components contact) =
    contact.examples


{-| -}
requestBodies : Components -> Dict String (ReferenceOr RequestBody)
requestBodies (Components contact) =
    contact.requestBodies


{-| -}
headers : Components -> Dict String (ReferenceOr Header)
headers (Components contact) =
    contact.headers


{-| -}
securitySchemes : Components -> Dict String (ReferenceOr SecurityScheme)
securitySchemes (Components contact) =
    contact.securitySchemes


{-| -}
links : Components -> Dict String (ReferenceOr Link)
links (Components contact) =
    contact.links


{-| -}
callbacks : Components -> Dict String (ReferenceOr Callback)
callbacks (Components contact) =
    contact.callbacks


{-| -}
pathItems : Components -> Dict String (ReferenceOr Path)
pathItems (Components contact) =
    contact.pathItems
