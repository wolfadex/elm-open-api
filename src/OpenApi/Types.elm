module OpenApi.Types exposing (Callback(..), CallbackInternal, Discriminator(..), DiscriminatorInternal, Encoding(..), EncodingInternal, Example(..), ExampleInternal, ExternalDocumentation(..), ExternalDocumentationInternal, Header(..), HeaderInternal, Link(..), LinkInternal, LinkRefOrId(..), Location(..), MediaType(..), MediaTypeInternal, Operation(..), OperationInternal, Parameter(..), ParameterInternal, Path(..), PathInternal, Reference(..), ReferenceInternal, ReferenceOr(..), RequestBody(..), RequestBodyInternal, Response(..), ResponseInternal, Schema(..), SchemaInternal, SecurityRequirement(..), SecurityRequirementInternal, Server(..), ServerInternal, Variable(..), VariableInternal, Xml(..), XmlInternal, decodeCallback, decodeDiscriminator, decodeEncoding, decodeExample, decodeExternalDocumentation, decodeHeader, decodeLink, decodeMediaType, decodeOperation, decodeOptionalDict, decodeParameter, decodePath, decodeRefOr, decodeReference, decodeRequestBody, decodeResponse, decodeSchema, decodeSecurityRequirement, decodeServer, decodeServerVariable, decodeXml, optionalNothing)

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
        |> Json.Decode.Pipeline.custom decodeLocation
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
    -- { discriminator : Maybe Discriminator
    -- , xml : Maybe Xml
    -- , externalDocs : Maybe ExternalDocumentation
    -- , example : Maybe Value
    -- }
    Value


decodeSchema : Decoder Schema
decodeSchema =
    -- Json.Decode.map4
    --     (\discriminator xml externalDocs example ->
    --         Schema
    --             { discriminator = discriminator
    --             , xml = xml
    --             , externalDocs = externalDocs
    --             , example = example
    --             }
    --     )
    --     (Json.Decode.Extra.optionalField "discriminator" decodeDiscriminator)
    --     (Json.Decode.Extra.optionalField "xml" decodeXml)
    --     (Json.Decode.Extra.optionalField "externalDocs" decodeExternalDocumentation)
    --     (Json.Decode.Extra.optionalField "example" Json.Decode.value)
    Json.Decode.map Schema
        Json.Decode.value



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



-- SecurityRequirement


type SecurityRequirement
    = SecurityRequirement SecurityRequirementInternal


type alias SecurityRequirementInternal =
    Dict String (List String)


decodeSecurityRequirement : Decoder SecurityRequirement
decodeSecurityRequirement =
    Json.Decode.map SecurityRequirement
        (Json.Decode.dict (Json.Decode.list Json.Decode.string))



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



-- Helpers


optionalNothing : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
optionalNothing fieldName decoder =
    Json.Decode.Pipeline.optional fieldName (Json.Decode.map Just decoder) Nothing


decodeOptionalDict : String -> Decoder a -> Decoder (Dict String a -> b) -> Decoder b
decodeOptionalDict field decoder =
    Json.Decode.Pipeline.optional field (Json.Decode.dict decoder) Dict.empty
