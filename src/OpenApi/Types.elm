module OpenApi.Types exposing (..)

import Dict exposing (Dict)
import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Decode.Pipeline
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


decodeEncoding : Decoder Encoding
decodeEncoding =
    Json.Decode.map5
        (\contentType_ headers_ style_ explode_ allowReserved_ ->
            Encoding
                { contentType = contentType_
                , headers = headers_
                , style = style_
                , explode = explode_
                , allowReserved = allowReserved_
                }
        )
        (Json.Decode.Extra.optionalField "contentType" Json.Decode.string)
        (Json.Decode.Extra.optionalField "headers"
            (Json.Decode.dict (decodeRefOr decodeHeader))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "style" Json.Decode.string)
        (Json.Decode.Extra.optionalField "explode" Json.Decode.bool)
        (Json.Decode.Extra.optionalField "allowReserved" Json.Decode.bool)



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


decodeRefOr : Decoder a -> Decoder (ReferenceOr a)
decodeRefOr decoder =
    Json.Decode.oneOf
        [ Json.Decode.map Other decoder
        , Json.Decode.map Ref decodeReference
        ]



-- Parameter


type Parameter
    = Parameter ParameterInternal


type alias ParameterInternal =
    { name : String
    , in_ : Location
    , description : Maybe String
    , required : Bool
    , deprecated : Bool
    , allowEmptyValue : Bool
    , schema : Maybe Schema
    , content : Dict String MediaType
    , example : String
    , examples : Dict String (ReferenceOr Example)
    }


type Location
    = LocQuery { style : String, explode : Bool, allowReserved : Bool }
    | LocHeader { style : String, explode : Bool }
    | LocPath { style : String, explode : Bool }
    | LocCookie { style : String, explode : Bool }


decodeParameter : Decoder Parameter
decodeParameter =
    Json.Decode.succeed
        (\name ( in_, required ) description deprecated allowEmptyValue schema content example examples ->
            Parameter
                { name = name
                , in_ = in_
                , description = description
                , required = required
                , deprecated = deprecated
                , allowEmptyValue = allowEmptyValue
                , schema = schema
                , content = content
                , example = example
                , examples = examples
                }
        )
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "in" decodeLocation
        |> Json.Decode.Pipeline.optional "description" (Json.Decode.maybe Json.Decode.string) Nothing
        |> Json.Decode.Pipeline.optional "deprecated"
            (Json.Decode.maybe Json.Decode.bool
                |> Json.Decode.map (Maybe.withDefault False)
            )
            False
        |> Json.Decode.Pipeline.optional "allowEmptyValue"
            (Json.Decode.maybe Json.Decode.bool
                |> Json.Decode.map (Maybe.withDefault False)
            )
            False
        |> Json.Decode.Pipeline.optional "schema" (Json.Decode.maybe decodeSchema) Nothing
        |> Json.Decode.Pipeline.optional "content" (Json.Decode.dict decodeMediaType) Dict.empty
        |> Json.Decode.Pipeline.optional "example" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "examples"
            (Json.Decode.dict (decodeRefOr decodeExample))
            Dict.empty


decodeLocation : Decoder ( Location, Bool )
decodeLocation =
    Json.Decode.string
        |> Json.Decode.andThen
            (\in_ ->
                case in_ of
                    "query" ->
                        decodeQuery

                    "header" ->
                        decodeLocHeader

                    "path" ->
                        decodeLocPath

                    "cookie" ->
                        decodeCookie

                    _ ->
                        Json.Decode.fail ("Unknown location `in` of " ++ in_)
            )


decodeQuery : Decoder ( Location, Bool )
decodeQuery =
    Json.Decode.map4
        (\style explode allowReserved required ->
            ( LocQuery
                { style = style
                , explode = explode
                , allowReserved = allowReserved
                }
            , Maybe.withDefault False required
            )
        )
        (Json.Decode.field "style" Json.Decode.string)
        (Json.Decode.field "explode" Json.Decode.bool)
        (Json.Decode.field "allowReserved" Json.Decode.bool)
        (Json.Decode.maybe (Json.Decode.field "required" Json.Decode.bool))


decodeLocHeader : Decoder ( Location, Bool )
decodeLocHeader =
    Json.Decode.map3
        (\style explode required ->
            ( LocHeader
                { style = style
                , explode = explode
                }
            , Maybe.withDefault False required
            )
        )
        (Json.Decode.field "style" Json.Decode.string)
        (Json.Decode.field "explode" Json.Decode.bool)
        (Json.Decode.maybe (Json.Decode.field "required" Json.Decode.bool))


decodeLocPath : Decoder ( Location, Bool )
decodeLocPath =
    Internal.andThen3
        (\style explode required ->
            if required then
                Json.Decode.succeed
                    ( LocPath
                        { style = style
                        , explode = explode
                        }
                    , required
                    )

            else
                Json.Decode.fail "If the location (`in`) is `path`, then `required` MUST be true"
        )
        (Json.Decode.field "style" Json.Decode.string)
        (Json.Decode.field "explode" Json.Decode.bool)
        (Json.Decode.field "required" Json.Decode.bool)


decodeCookie : Decoder ( Location, Bool )
decodeCookie =
    Json.Decode.map3
        (\style explode required ->
            ( LocCookie
                { style = style
                , explode = explode
                }
            , Maybe.withDefault False required
            )
        )
        (Json.Decode.field "style" Json.Decode.string)
        (Json.Decode.field "explode" Json.Decode.bool)
        (Json.Decode.maybe (Json.Decode.field "required" Json.Decode.bool))



-- Header


type Header
    = Header HeaderInternal


type alias HeaderInternal =
    { style : String
    , explode : Bool
    , description : Maybe String
    , required : Bool
    , deprecated : Bool
    , allowEmptyValue : Bool
    , schema : Maybe Schema
    , content : Dict String MediaType
    , example : String
    , examples : Dict String (ReferenceOr Example)
    }


decodeHeader : Decoder Header
decodeHeader =
    Json.Decode.succeed
        (\style explode required description deprecated allowEmptyValue schema content example examples ->
            Header
                { style = style
                , explode = explode
                , description = description
                , required = required
                , deprecated = deprecated
                , allowEmptyValue = allowEmptyValue
                , schema = schema
                , content = content
                , example = example
                , examples = examples
                }
        )
        |> Json.Decode.Pipeline.required "style" Json.Decode.string
        |> Json.Decode.Pipeline.optional "explode" Json.Decode.bool False
        |> Json.Decode.Pipeline.optional "required" Json.Decode.bool False
        |> Json.Decode.Pipeline.optional "description" (Json.Decode.maybe Json.Decode.string) Nothing
        |> Json.Decode.Pipeline.optional "deprecated"
            (Json.Decode.maybe Json.Decode.bool
                |> Json.Decode.map (Maybe.withDefault False)
            )
            False
        |> Json.Decode.Pipeline.optional "allowEmptyValue"
            (Json.Decode.maybe Json.Decode.bool
                |> Json.Decode.map (Maybe.withDefault False)
            )
            False
        |> Json.Decode.Pipeline.optional "schema" (Json.Decode.maybe decodeSchema) Nothing
        |> Json.Decode.Pipeline.optional "content" (Json.Decode.dict decodeMediaType) Dict.empty
        |> Json.Decode.Pipeline.optional "example" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "examples" (Json.Decode.dict (decodeRefOr decodeExample)) Dict.empty



-- Schema


type Schema
    = Schema SchemaInternal


type alias SchemaInternal =
    Json.Decode.Value


decodeSchema : Decoder Schema
decodeSchema =
    Json.Decode.map
        (\schema_ ->
            Debug.todo "implement schema"
        )
        Json.Decode.value



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


decodeMediaType : Decoder MediaType
decodeMediaType =
    Json.Decode.map4
        (\schema_ example_ examples_ encoding_ ->
            MediaType
                { schema = schema_
                , example = example_
                , examples = examples_
                , encoding = encoding_
                }
        )
        (Json.Decode.Extra.optionalField "schema" decodeSchema)
        (Json.Decode.Extra.optionalField "example" Json.Decode.value)
        (Json.Decode.Extra.optionalField "examples"
            (Json.Decode.dict (decodeRefOr decodeExample))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "encoding" (Json.Decode.dict decodeEncoding)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )



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



-- Path


type Path
    = Path PathInternal


type alias PathInternal =
    { summary : Maybe String
    , description : Maybe String
    , get : Maybe Operation
    , put : Maybe Operation
    , post : Maybe Operation
    , delete : Maybe Operation
    , options : Maybe Operation
    , head : Maybe Operation
    , patch : Maybe Operation
    , trace : Maybe Operation
    , servers : List Server
    , parameters : List (ReferenceOr Parameter)
    }


decodePath : Decoder Path
decodePath =
    Json.Decode.succeed
        (\summary description get put post delete options head patch trace servers parameters ->
            Path
                { summary = summary
                , description = description
                , get = get
                , put = put
                , post = post
                , delete = delete
                , options = options
                , head = head
                , patch = patch
                , trace = trace
                , servers = servers
                , parameters = parameters
                }
        )
        |> optionalNothing "summary" Json.Decode.string
        |> optionalNothing "description" Json.Decode.string
        |> optionalNothing "get" decodeOperation
        |> optionalNothing "put" decodeOperation
        |> optionalNothing "post" decodeOperation
        |> optionalNothing "delete" decodeOperation
        |> optionalNothing "options" decodeOperation
        |> optionalNothing "head" decodeOperation
        |> optionalNothing "patch" decodeOperation
        |> optionalNothing "trace" decodeOperation
        |> Json.Decode.Pipeline.optional "servers" (Json.Decode.list decodeServer) []
        |> Json.Decode.Pipeline.optional "parameters" (Json.Decode.list (decodeRefOr decodeParameter)) []


optionalNothing : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
optionalNothing fieldName decoder =
    Json.Decode.Pipeline.optional fieldName (Json.Decode.map Just decoder) Nothing



-- Operation


type Operation
    = Operation OperationInternal


type alias OperationInternal =
    {}


decodeOperation : Decoder Operation
decodeOperation =
    Debug.todo ""



-- Server


type Server
    = Server ServerInternal


type alias ServerInternal =
    { description : Maybe String
    , url : String
    , variables : Dict String Variable
    }


decodeServer : Decoder Server
decodeServer =
    Json.Decode.map3
        (\description_ url_ variables_ ->
            Server
                { description = description_
                , url = url_
                , variables = variables_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.field "url" Json.Decode.string)
        (Json.Decode.Extra.optionalField "variables" (Json.Decode.dict decodeServerVariable)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )



-- Server Variable


type Variable
    = Variable VariableInternal


type alias VariableInternal =
    { enum : List String
    , default : String
    , description : Maybe String
    }


decodeServerVariable : Decoder Variable
decodeServerVariable =
    Json.Decode.map3
        (\description_ default_ enum_ ->
            Variable
                { description = description_
                , default = default_
                , enum = enum_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.field "default" Json.Decode.string)
        (Json.Decode.Extra.optionalField "enum" (Json.Decode.list Json.Decode.string)
            |> Json.Decode.map (Maybe.withDefault [])
        )
