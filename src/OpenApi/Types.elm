module OpenApi.Types exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Encode exposing (Value)



-- Encoding


type Encoding
    = Encoding EncodingInternal


type alias EncodingInternal =
    { contentType : Maybe String
    , headers : Dict String (ReferenceOr Header)
    , style : Maybe String
    , explode : Maybe Bool
    , allowReserved : Maybe Bool
    }



-- Reference


type Reference
    = Reference ReferenceInternal


type alias ReferenceInternal =
    { ref : String
    , summary : Maybe String
    , description : Maybe String
    }


type ReferenceOr a
    = Ref Reference
    | Other a


decodeReference : Decoder Reference
decodeReference =
    Json.Decode.map3
        (\ref_ summary_ description_ ->
            Reference
                { ref = ref_
                , summary = summary_
                , description = description_
                }
        )
        (Json.Decode.field "$ref" Json.Decode.string)
        (Json.Decode.Extra.optionalField "summary" Json.Decode.string)
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)


decodeOr : Decoder a -> Decoder (ReferenceOr a)
decodeOr decoder =
    Json.Decode.oneOf
        [ Json.Decode.map Other decoder
        , Json.Decode.map Ref decodeReference
        ]



-- Header


type Header
    = Header HeaderInternal


type alias HeaderInternal =
    {}


decodeHeader : Decoder Header
decodeHeader =
    Debug.todo ""



-- Schema


type Schema
    = Schema SchemaInternal


type alias SchemaInternal =
    Json.Decode.Value



-- RequestBody


type RequestBody
    = RequestBody RequestBodyInternal


type alias RequestBodyInternal =
    { description : Maybe String
    , content : Dict String MediaType
    , required : Bool
    }



--MediaType


type MediaType
    = MediaType MediaTypeInternal


type alias MediaTypeInternal =
    { schema : Maybe Schema
    , example : Maybe Value
    , examples : Dict String (ReferenceOr Example)
    , encoding : Dict String Encoding
    }



-- Example


type Example
    = Example ExampleInternal


type alias ExampleInternal =
    { summary : Maybe String
    , description : Maybe String
    , value : Maybe Value
    , externalValue : Maybe String
    }


decodeExample : Decoder Example
decodeExample =
    Json.Decode.map4
        (\summary_ description_ value_ externalValue_ ->
            Example
                { summary = summary_
                , description = description_
                , value = value_
                , externalValue = externalValue_
                }
        )
        (Json.Decode.Extra.optionalField "summary" Json.Decode.string)
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "value" Json.Decode.value)
        (Json.Decode.Extra.optionalField "externalValue" Json.Decode.string)
