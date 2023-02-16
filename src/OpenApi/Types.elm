module OpenApi.Types exposing
    ( Callback(..)
    , CallbackInternal
    , Discriminator(..)
    , DiscriminatorInternal
    , Encoding(..)
    , EncodingInternal
    , Example(..)
    , ExampleInternal
    , ExternalDocumentation(..)
    , ExternalDocumentationInternal
    , Header(..)
    , HeaderInternal
    , Link(..)
    , LinkInternal
    , LinkRefOrId(..)
    , Location(..)
    , MediaType(..)
    , MediaTypeInternal
    , Operation(..)
    , OperationInternal
    , Parameter(..)
    , ParameterInternal
    , Path(..)
    , PathInternal
    , Reference(..)
    , ReferenceInternal
    , ReferenceOr(..)
    , RequestBody(..)
    , RequestBodyInternal
    , Response(..)
    , ResponseInternal
    , Schema(..)
    , SchemaInternal
    , SecurityRequirement(..)
    , SecurityRequirementInternal
    , Server(..)
    , ServerInternal
    , Variable(..)
    , VariableInternal
    , Xml(..)
    , XmlInternal
    , decodeCallback
    , decodeDiscriminator
    , decodeEncoding
    , decodeExample
    , decodeExternalDocumentation
    , decodeHeader
    , decodeLink
    , decodeMediaType
    , decodeOperation
    , decodeOptionalDict
    , decodeParameter
    , decodePath
    , decodeRefOr
    , decodeReference
    , decodeRequestBody
    , decodeResponse
    , decodeSchema
    , decodeSecurityRequirement
    , decodeServer
    , decodeServerVariable
    , decodeXml
    , encodeExternalDocumentation
    , encodePath
    , encodeRefOr
    , encodeSecurityRequirement
    , encodeServer
    , encodeServerVariable
    , optionalNothing
    )

import Dict exposing (Dict)
import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Decode.Pipeline
import Json.Encode exposing (Value)
import Json.Schema.Definitions



-- Encoding


type Encoding
    = Encoding EncodingInternal


type alias EncodingInternal =
    { contentType : Maybe String
    , headers : Dict String (ReferenceOr Header)
    , style : Maybe String
    , explode : Bool
    , allowReserved : Bool
    }


decodeEncoding : Decoder Encoding
decodeEncoding =
    Json.Decode.map5
        (\contentType_ headers_ style_ explode_ allowReserved_ ->
            Encoding
                { contentType = contentType_
                , headers = headers_
                , style = style_
                , explode = Maybe.withDefault (style_ == Just "form") explode_
                , allowReserved = Maybe.withDefault False allowReserved_
                }
        )
        (Json.Decode.Extra.optionalField "contentType" Json.Decode.string)
        (Json.Decode.Extra.optionalField "headers"
            (Json.Decode.dict (decodeRefOr (Json.Decode.lazy (\() -> decodeHeader))))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "style" Json.Decode.string)
        (Json.Decode.Extra.optionalField "explode" Json.Decode.bool)
        (Json.Decode.Extra.optionalField "allowReserved" Json.Decode.bool)


encodeEncoding : Encoding -> Json.Encode.Value
encodeEncoding (Encoding encoding) =
    [ Internal.maybeEncodeField ( "contentType", Json.Encode.string ) encoding.contentType
    , Internal.maybeEncodeDictField ( "headers", identity, encodeRefOr encodeHeader ) encoding.headers
    , Internal.maybeEncodeField ( "style", Json.Encode.string ) encoding.style
    , Just ( "explode", Json.Encode.bool encoding.explode )
    , Just ( "allowReserved", Json.Encode.bool encoding.allowReserved )
    ]
        |> List.filterMap identity
        |> Json.Encode.object



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
        [ Json.Decode.map Ref decodeReference
        , Json.Decode.map Other decoder
        ]


encodeRefOr : (a -> Json.Encode.Value) -> ReferenceOr a -> Json.Encode.Value
encodeRefOr encoder refOr =
    case refOr of
        Ref (Reference reference) ->
            [ Just ( "$ref", Json.Encode.string reference.ref )
            , Internal.maybeEncodeField ( "summary", Json.Encode.string ) reference.summary
            , Internal.maybeEncodeField ( "description", Json.Encode.string ) reference.description
            ]
                |> List.filterMap identity
                |> Json.Encode.object

        Other a ->
            encoder a



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
    , example : Maybe Value
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
        |> Json.Decode.Pipeline.custom decodeLocation
        |> optionalNothing "description" Json.Decode.string
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
        |> optionalNothing "schema" decodeSchema
        |> Json.Decode.Pipeline.optional "content" (Json.Decode.dict decodeMediaType) Dict.empty
        |> optionalNothing "example" Json.Decode.value
        |> Json.Decode.Pipeline.optional "examples" (Json.Decode.dict (decodeRefOr decodeExample)) Dict.empty


encodeParameter : Parameter -> Json.Encode.Value
encodeParameter (Parameter parameter) =
    [ Just ( "name", Json.Encode.string parameter.name )
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) parameter.description
    , Just ( "deprecated", Json.Encode.bool parameter.deprecated )
    , Just ( "required", Json.Encode.bool parameter.required )
    , Just ( "allowEmptyValue", Json.Encode.bool parameter.allowEmptyValue )
    , Internal.maybeEncodeField ( "schema", encodeSchema ) parameter.schema
    , Internal.maybeEncodeDictField ( "content", identity, encodeMediaType ) parameter.content
    , Internal.maybeEncodeField ( "example", identity ) parameter.example
    , Internal.maybeEncodeDictField ( "examples", identity, encodeRefOr encodeExample ) parameter.examples
    ]
        |> List.filterMap identity
        |> List.append (encodeLocation parameter.in_)
        |> Json.Encode.object


decodeLocation : Decoder ( Location, Bool )
decodeLocation =
    Json.Decode.field "in" Json.Decode.string
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


encodeLocation : Location -> List ( String, Json.Encode.Value )
encodeLocation location =
    case location of
        LocQuery { style, explode, allowReserved } ->
            [ ( "in", Json.Encode.string "query" )
            , ( "style", Json.Encode.string style )
            , ( "explode", Json.Encode.bool explode )
            , ( "allowReserved", Json.Encode.bool allowReserved )
            ]

        LocHeader { style, explode } ->
            [ ( "in", Json.Encode.string "header" )
            , ( "style", Json.Encode.string style )
            , ( "explode", Json.Encode.bool explode )
            ]

        LocPath { style, explode } ->
            [ ( "in", Json.Encode.string "path" )
            , ( "style", Json.Encode.string style )
            , ( "explode", Json.Encode.bool explode )
            ]

        LocCookie { style, explode } ->
            [ ( "in", Json.Encode.string "cookie" )
            , ( "style", Json.Encode.string style )
            , ( "explode", Json.Encode.bool explode )
            ]


decodeQuery : Decoder ( Location, Bool )
decodeQuery =
    Json.Decode.map4
        (\style explode allowReserved required ->
            let
                style_ : String
                style_ =
                    Maybe.withDefault "form" style
            in
            ( LocQuery
                { style = style_
                , explode = Maybe.withDefault (style_ == "form") explode
                , allowReserved = Maybe.withDefault False allowReserved
                }
            , Maybe.withDefault False required
            )
        )
        (Json.Decode.Extra.optionalField "style" Json.Decode.string)
        (Json.Decode.Extra.optionalField "explode" Json.Decode.bool)
        (Json.Decode.Extra.optionalField "allowReserved" Json.Decode.bool)
        (Json.Decode.Extra.optionalField "required" Json.Decode.bool)


decodeLocHeader : Decoder ( Location, Bool )
decodeLocHeader =
    Json.Decode.map3
        (\style explode required ->
            let
                style_ : String
                style_ =
                    Maybe.withDefault "simple" style
            in
            ( LocHeader
                { style = style_
                , explode = Maybe.withDefault (style_ == "form") explode
                }
            , Maybe.withDefault False required
            )
        )
        (Json.Decode.Extra.optionalField "style" Json.Decode.string)
        (Json.Decode.Extra.optionalField "explode" Json.Decode.bool)
        (Json.Decode.Extra.optionalField "required" Json.Decode.bool)


decodeLocPath : Decoder ( Location, Bool )
decodeLocPath =
    Internal.andThen3
        (\style explode required ->
            if required then
                let
                    style_ : String
                    style_ =
                        Maybe.withDefault "simple" style
                in
                Json.Decode.succeed
                    ( LocPath
                        { style = style_
                        , explode = Maybe.withDefault (style_ == "form") explode
                        }
                    , required
                    )

            else
                Json.Decode.fail "If the location (`in`) is `path`, then `required` MUST be true"
        )
        (Json.Decode.Extra.optionalField "style" Json.Decode.string)
        (Json.Decode.Extra.optionalField "explode" Json.Decode.bool)
        (Json.Decode.field "required" Json.Decode.bool)


decodeCookie : Decoder ( Location, Bool )
decodeCookie =
    Json.Decode.map3
        (\style explode required ->
            let
                style_ : String
                style_ =
                    Maybe.withDefault "form" style
            in
            ( LocCookie
                { style = style_
                , explode = Maybe.withDefault (style_ == "form") explode
                }
            , Maybe.withDefault False required
            )
        )
        (Json.Decode.Extra.optionalField "style" Json.Decode.string)
        (Json.Decode.Extra.optionalField "explode" Json.Decode.bool)
        (Json.Decode.Extra.optionalField "required" Json.Decode.bool)



-- Header


type Header
    = Header HeaderInternal


type alias HeaderInternal =
    { style : Maybe String
    , explode : Bool
    , description : Maybe String
    , required : Bool
    , deprecated : Bool
    , allowEmptyValue : Bool
    , schema : Maybe Schema
    , content : Dict String MediaType
    , example : Maybe Value
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
        |> optionalNothing "style" Json.Decode.string
        |> Json.Decode.Pipeline.optional "explode" Json.Decode.bool False
        |> Json.Decode.Pipeline.optional "required" Json.Decode.bool False
        |> optionalNothing "description" Json.Decode.string
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
        |> optionalNothing "schema" decodeSchema
        |> Json.Decode.Pipeline.optional "content" (Json.Decode.dict decodeMediaType) Dict.empty
        |> optionalNothing "example" Json.Decode.value
        |> Json.Decode.Pipeline.optional "examples" (Json.Decode.dict (decodeRefOr decodeExample)) Dict.empty


encodeHeader : Header -> Json.Encode.Value
encodeHeader (Header header) =
    [ Internal.maybeEncodeField ( "style", Json.Encode.string ) header.style
    , Just ( "explode", Json.Encode.bool header.explode )
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) header.description
    , Just ( "required", Json.Encode.bool header.required )
    , Just ( "deprecated", Json.Encode.bool header.deprecated )
    , Just ( "allowEmptyValue", Json.Encode.bool header.allowEmptyValue )
    , Internal.maybeEncodeField ( "schema", encodeSchema ) header.schema
    , Internal.maybeEncodeDictField ( "content", identity, encodeMediaType ) header.content
    , Internal.maybeEncodeField ( "example", identity ) header.example
    , Internal.maybeEncodeDictField ( "examples", identity, encodeRefOr encodeExample ) header.examples
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- Schema


type Schema
    = Schema SchemaInternal


type alias SchemaInternal =
    Json.Schema.Definitions.Schema


decodeSchema : Decoder Schema
decodeSchema =
    Json.Decode.map Schema
        Json.Schema.Definitions.decoder


encodeSchema : Schema -> Json.Encode.Value
encodeSchema (Schema schema) =
    Json.Schema.Definitions.encode schema



-- Discriminator


type Discriminator
    = Discriminator DiscriminatorInternal


type alias DiscriminatorInternal =
    { propertyName : String
    , mapping : Dict String String
    }


decodeDiscriminator : Decoder Discriminator
decodeDiscriminator =
    Json.Decode.map2
        (\propertyName mapping ->
            Discriminator
                { propertyName = propertyName
                , mapping = mapping
                }
        )
        (Json.Decode.field "propertyName" Json.Decode.string)
        (Json.Decode.field "mapping" (Json.Decode.dict Json.Decode.string))



-- Xml


type Xml
    = Xml XmlInternal


type alias XmlInternal =
    { name : Maybe String
    , namespace : Maybe String
    , prefix : Maybe String
    , attribute : Bool
    , wrapped : Bool
    }


decodeXml : Decoder Xml
decodeXml =
    Json.Decode.map5
        (\name namespace prefix attribute wrapped ->
            Xml
                { name = name
                , namespace = namespace
                , prefix = prefix
                , attribute = attribute
                , wrapped = wrapped
                }
        )
        (Json.Decode.Extra.optionalField "name" Json.Decode.string)
        (Json.Decode.Extra.optionalField "namespace" Json.Decode.string)
        (Json.Decode.Extra.optionalField "prefix" Json.Decode.string)
        (Json.Decode.maybe (Json.Decode.field "name" Json.Decode.bool)
            |> Json.Decode.map (Maybe.withDefault False)
        )
        (Json.Decode.maybe (Json.Decode.field "name" Json.Decode.bool)
            |> Json.Decode.map (Maybe.withDefault False)
        )



-- RequestBody


type RequestBody
    = RequestBody RequestBodyInternal


type alias RequestBodyInternal =
    { description : Maybe String
    , content : Dict String MediaType
    , required : Bool
    }


decodeRequestBody : Decoder RequestBody
decodeRequestBody =
    Json.Decode.map3
        (\description_ content_ required_ ->
            RequestBody
                { description = description_
                , content = content_
                , required = required_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "content" (Json.Decode.dict decodeMediaType)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "required" Json.Decode.bool
            |> Json.Decode.map (Maybe.withDefault False)
        )


encodeRequestBody : RequestBody -> Json.Encode.Value
encodeRequestBody (RequestBody requestBody) =
    [ Internal.maybeEncodeField ( "description", Json.Encode.string ) requestBody.description
    , Internal.maybeEncodeDictField ( "content", identity, encodeMediaType ) requestBody.content
    , Just ( "required", Json.Encode.bool requestBody.required )
    ]
        |> List.filterMap identity
        |> Json.Encode.object



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


encodeMediaType : MediaType -> Json.Encode.Value
encodeMediaType (MediaType mediaType) =
    [ Internal.maybeEncodeField ( "schema", encodeSchema ) mediaType.schema
    , Internal.maybeEncodeField ( "example", identity ) mediaType.example
    , Internal.maybeEncodeDictField ( "examples", identity, encodeRefOr encodeExample ) mediaType.examples
    , Internal.maybeEncodeDictField ( "encoding", identity, encodeEncoding ) mediaType.encoding
    ]
        |> List.filterMap identity
        |> Json.Encode.object



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


encodeExample : Example -> Json.Encode.Value
encodeExample (Example example) =
    [ Internal.maybeEncodeField ( "summary", Json.Encode.string ) example.summary
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) example.description
    , Internal.maybeEncodeField ( "value", identity ) example.value
    , Internal.maybeEncodeField ( "externalValue", Json.Encode.string ) example.externalValue
    ]
        |> List.filterMap identity
        |> Json.Encode.object



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


encodePath : Path -> Json.Encode.Value
encodePath (Path path) =
    [ Internal.maybeEncodeField ( "summary", Json.Encode.string ) path.summary
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) path.description
    , Internal.maybeEncodeField ( "get", encodeOperation ) path.get
    , Internal.maybeEncodeField ( "put", encodeOperation ) path.put
    , Internal.maybeEncodeField ( "post", encodeOperation ) path.post
    , Internal.maybeEncodeField ( "delete", encodeOperation ) path.delete
    , Internal.maybeEncodeField ( "options", encodeOperation ) path.options
    , Internal.maybeEncodeField ( "head", encodeOperation ) path.head
    , Internal.maybeEncodeField ( "patch", encodeOperation ) path.patch
    , Internal.maybeEncodeField ( "trace", encodeOperation ) path.trace
    , Internal.maybeEncodeListField ( "servers", encodeServer ) path.servers
    , Internal.maybeEncodeListField ( "parameters", encodeRefOr encodeParameter ) path.parameters
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- Operation


type Operation
    = Operation OperationInternal


type alias OperationInternal =
    { tags : List String
    , summary : Maybe String
    , description : Maybe String
    , externalDocs : Maybe ExternalDocumentation
    , operationId : Maybe String
    , parameters : List (ReferenceOr Parameter)
    , requestBody : Maybe (ReferenceOr RequestBody)
    , responses : Dict String (ReferenceOr Response)
    , callbacks : Dict String (ReferenceOr Callback)
    , deprecated : Bool
    , security : List SecurityRequirement
    , servers : List Server
    }


decodeOperation : Decoder Operation
decodeOperation =
    Json.Decode.succeed
        (\tags summary description externalDocs operationId parameters requestBody responses callbacks deprecated security servers ->
            { tags = tags
            , summary = summary
            , description = description
            , externalDocs = externalDocs
            , operationId = operationId
            , parameters = parameters
            , requestBody = requestBody
            , responses = responses
            , callbacks = callbacks
            , deprecated = deprecated
            , security = security
            , servers = servers
            }
        )
        |> Json.Decode.Pipeline.optional "tags" (Json.Decode.list Json.Decode.string) []
        |> optionalNothing "summary" Json.Decode.string
        |> optionalNothing "description" Json.Decode.string
        |> optionalNothing "externalDocs" decodeExternalDocumentation
        |> optionalNothing "operationId" Json.Decode.string
        |> Json.Decode.Pipeline.optional "parameters" (Json.Decode.list (decodeRefOr decodeParameter)) []
        |> optionalNothing "requestBody" (decodeRefOr decodeRequestBody)
        |> decodeOptionalDict "responses" (decodeRefOr decodeResponse)
        |> Json.Decode.Pipeline.optional "callbacks" (Json.Decode.dict (decodeRefOr decodeCallback)) Dict.empty
        |> Json.Decode.Pipeline.optional "deprecated" Json.Decode.bool False
        |> Json.Decode.Pipeline.optional "security" (Json.Decode.list decodeSecurityRequirement) []
        |> Json.Decode.Pipeline.optional "servers" (Json.Decode.list decodeServer) []
        |> Json.Decode.andThen
            (\operation ->
                if Dict.isEmpty operation.responses then
                    Json.Decode.fail "At least 1 response is required for an operation, none were found"

                else
                    Json.Decode.succeed (Operation operation)
            )


encodeOperation : Operation -> Json.Encode.Value
encodeOperation (Operation operation) =
    [ Internal.maybeEncodeListField ( "tags", Json.Encode.string ) operation.tags
    , Internal.maybeEncodeField ( "summary", Json.Encode.string ) operation.summary
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) operation.description
    , Internal.maybeEncodeField ( "externalDocs", encodeExternalDocumentation ) operation.externalDocs
    , Internal.maybeEncodeField ( "operationId", Json.Encode.string ) operation.operationId
    , Internal.maybeEncodeListField ( "parameters", encodeRefOr encodeParameter ) operation.parameters
    , Internal.maybeEncodeField ( "requestBody", encodeRefOr encodeRequestBody ) operation.requestBody
    , Just ( "responses", Json.Encode.dict identity (encodeRefOr encodeResponse) operation.responses )
    , Internal.maybeEncodeDictField ( "callbacks", identity, encodeRefOr encodeCallback ) operation.callbacks
    , Just ( "deprecated", Json.Encode.bool operation.deprecated )
    , Internal.maybeEncodeListField ( "security", encodeSecurityRequirement ) operation.security
    , Internal.maybeEncodeListField ( "servers", encodeServer ) operation.servers
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- SecurityRequirement


type SecurityRequirement
    = SecurityRequirement SecurityRequirementInternal


type alias SecurityRequirementInternal =
    Dict String (List String)


decodeSecurityRequirement : Decoder SecurityRequirement
decodeSecurityRequirement =
    Json.Decode.map SecurityRequirement
        (Json.Decode.dict (Json.Decode.list Json.Decode.string))


encodeSecurityRequirement : SecurityRequirement -> Json.Encode.Value
encodeSecurityRequirement (SecurityRequirement securityRequirement) =
    Json.Encode.dict identity (Json.Encode.list Json.Encode.string) securityRequirement



-- Callback


type Callback
    = Callback CallbackInternal


type alias CallbackInternal =
    { expression : String
    , refOrPath : ReferenceOr Path
    }


decodeCallback : Decoder Callback
decodeCallback =
    Json.Decode.dict (Json.Decode.lazy (\() -> decodeRefOr decodePath))
        |> Json.Decode.andThen
            (\dict ->
                case Dict.toList dict of
                    [ ( expression, refOrPath ) ] ->
                        Callback
                            { expression = expression
                            , refOrPath = refOrPath
                            }
                            |> Json.Decode.succeed

                    _ ->
                        Json.Decode.fail "Expected a single expression but found zero or multiple"
            )


encodeCallback : Callback -> Json.Encode.Value
encodeCallback (Callback callback) =
    Debug.todo "encode callback"



-- Response


type Response
    = Response ResponseInternal


type alias ResponseInternal =
    { description : String
    , headers : Dict String (ReferenceOr Header)
    , content : Dict String MediaType
    , links : Dict String (ReferenceOr Link)
    }


decodeResponse : Decoder Response
decodeResponse =
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
            (Json.Decode.dict (decodeRefOr decodeHeader))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "content"
            (Json.Decode.dict decodeMediaType)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "links"
            (Json.Decode.dict (decodeRefOr decodeLink))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )


encodeResponse : Response -> Json.Encode.Value
encodeResponse (Response response) =
    [ Just ( "description", Json.Encode.string response.description )
    , Internal.maybeEncodeDictField ( "headers", identity, encodeRefOr encodeHeader ) response.headers
    , Internal.maybeEncodeDictField ( "content", identity, encodeMediaType ) response.content
    , Internal.maybeEncodeDictField ( "links", identity, encodeRefOr encodeLink ) response.links
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- Link


type Link
    = Link LinkInternal


type alias LinkInternal =
    { operationRefOrId : Maybe LinkRefOrId
    , parameters : Dict String Value
    , requestBody : Maybe Value
    , description : Maybe String
    , server : Maybe Server
    }


type LinkRefOrId
    = LinkRef String
    | LinkId String



-- Decoding


{-| -}
decodeLink : Decoder Link
decodeLink =
    Json.Decode.map5
        (\operationRefOrId_ parameters_ requestBody_ description_ server_ ->
            Link
                { operationRefOrId = operationRefOrId_
                , parameters = parameters_
                , requestBody = requestBody_
                , description = description_
                , server = server_
                }
        )
        decodeLinkRefOrId
        (Json.Decode.Extra.optionalField "parameters" (Json.Decode.dict Json.Decode.value)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "requestBody" Json.Decode.value)
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "server" decodeServer)


encodeLink : Link -> Json.Encode.Value
encodeLink (Link link) =
    [ Internal.maybeEncodeDictField ( "parameters", identity, identity ) link.parameters
    , Internal.maybeEncodeField ( "requestBody", identity ) link.requestBody
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) link.description
    , Internal.maybeEncodeField ( "server", encodeServer ) link.server
    ]
        |> List.filterMap identity
        |> List.append (encodeLinkRefOrId link.operationRefOrId)
        |> Json.Encode.object


decodeLinkRefOrId : Decoder (Maybe LinkRefOrId)
decodeLinkRefOrId =
    Internal.andThen2
        (\operationRef_ operationId_ ->
            case ( operationRef_, operationId_ ) of
                ( Nothing, Nothing ) ->
                    Json.Decode.succeed Nothing

                ( Just ref, Nothing ) ->
                    Json.Decode.succeed (Just (LinkRef ref))

                ( Nothing, Just id ) ->
                    Json.Decode.succeed (Just (LinkId id))

                ( Just _, Just _ ) ->
                    Json.Decode.fail "A Link Object cannot have both an operationRef and an operationId, but I found both."
        )
        (Json.Decode.Extra.optionalField "operationRef" Json.Decode.string)
        (Json.Decode.Extra.optionalField "operationId" Json.Decode.string)


encodeLinkRefOrId : Maybe LinkRefOrId -> List ( String, Json.Encode.Value )
encodeLinkRefOrId maybeLinkRefOrId =
    case maybeLinkRefOrId of
        Nothing ->
            []

        Just (LinkRef operationRef) ->
            [ ( "operationRef", Json.Encode.string operationRef ) ]

        Just (LinkId operationId) ->
            [ ( "operationId", Json.Encode.string operationId ) ]



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


encodeServer : Server -> Json.Encode.Value
encodeServer (Server server) =
    [ Internal.maybeEncodeField ( "description", Json.Encode.string ) server.description
    , Just ( "url", Json.Encode.string server.url )
    , Internal.maybeEncodeDictField ( "variables", identity, encodeServerVariable ) server.variables
    ]
        |> List.filterMap identity
        |> Json.Encode.object



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


encodeServerVariable : Variable -> Json.Encode.Value
encodeServerVariable (Variable variable) =
    [ Internal.maybeEncodeListField ( "enum", Json.Encode.string ) variable.enum
    , Just ( "default", Json.Encode.string variable.default )
    , Internal.maybeEncodeField ( "description", Json.Encode.string ) variable.description
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- External Documentation


type ExternalDocumentation
    = ExternalDocumentation ExternalDocumentationInternal


type alias ExternalDocumentationInternal =
    { description : Maybe String
    , url : String
    }


decodeExternalDocumentation : Decoder ExternalDocumentation
decodeExternalDocumentation =
    Json.Decode.map2
        (\description_ url_ ->
            ExternalDocumentation
                { description = description_
                , url = url_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.field "url" Json.Decode.string)


encodeExternalDocumentation : ExternalDocumentation -> Json.Encode.Value
encodeExternalDocumentation (ExternalDocumentation externalDocs) =
    [ Internal.maybeEncodeField ( "description", Json.Encode.string ) externalDocs.description
    , Just ( "url", Json.Encode.string externalDocs.url )
    ]
        |> List.filterMap identity
        |> Json.Encode.object



-- Helpers


optionalNothing : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
optionalNothing fieldName decoder =
    Json.Decode.Pipeline.optional fieldName (Json.Decode.map Just decoder) Nothing


decodeOptionalDict : String -> Decoder a -> Decoder (Dict String a -> b) -> Decoder b
decodeOptionalDict field decoder =
    Json.Decode.Pipeline.optional field (Json.Decode.dict decoder) Dict.empty
