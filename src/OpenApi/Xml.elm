module OpenApi.Xml exposing
    ( Xml
    , decode
    , encode
    , attribute
    , name
    , namespace
    , prefix
    , wrapped
    )

{-| Corresponds to the [XML Object](https://spec.openapis.org/oas/latest#xml-object) in the OpenAPI specification.


# Types

@docs Xml


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs attribute
@docs name
@docs namespace
@docs prefix
@docs wrapped

-}

import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.Types exposing (Xml)


{-| -}
type alias Xml =
    OpenApi.Types.Xml


{-| -}
decode : Decoder Xml
decode =
    OpenApi.Types.decodeXml


{-| -}
encode : Xml -> Json.Encode.Value
encode =
    OpenApi.Types.encodeXml


{-| -}
name : Xml -> Maybe String
name (OpenApi.Types.Xml xml) =
    xml.name


{-| -}
namespace : Xml -> Maybe String
namespace (OpenApi.Types.Xml xml) =
    xml.namespace


{-| -}
prefix : Xml -> Maybe String
prefix (OpenApi.Types.Xml xml) =
    xml.prefix


{-| -}
attribute : Xml -> Bool
attribute (OpenApi.Types.Xml xml) =
    xml.attribute


{-| -}
wrapped : Xml -> Bool
wrapped (OpenApi.Types.Xml xml) =
    xml.wrapped
