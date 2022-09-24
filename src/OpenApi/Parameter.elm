module OpenApi.Parameter exposing
    ( Location(..)
    , Parameter
    , decode
    )

import Dict exposing (Dict)
import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline
import OpenApi.MediaType exposing (MediaType)
import OpenApi.Schema exposing (Schema)
import OpenApi.Types exposing (Example, ReferenceOr)


type Parameter
    = Parameter Internal


type alias Internal =
    { name : String
    , in_ : Location
    , description : Maybe String
    , required : Bool
    , deprecated : Bool
    , allowEmptyValue : Bool
    , schemaOrContent : SchemaOrContent
    , example : String
    , examples : Dict String (ReferenceOr Example)
    }


type Location
    = LocQuery { style : String, explode : Bool, allowReserved : Bool }
    | LocHeader { style : String, explode : Bool }
    | LocPath { style : String, explode : Bool }
    | LocCookie { style : String, explode : Bool }


type SchemaOrContent
    = SCSchema Schema
    | SCContent (Dict String MediaType)


decode : Decoder Parameter
decode =
    Json.Decode.succeed
        (\name ( in_, required ) description deprecated allowEmptyValue schemaOrContent example examples ->
            Parameter
                { name = name
                , in_ = in_
                , description = description
                , required = required
                , deprecated = deprecated
                , allowEmptyValue = allowEmptyValue
                , schemaOrContent = schemaOrContent
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
        |> Debug.todo ""
        |> Json.Decode.Pipeline.optional "example" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "examples"
            (Json.Decode.dict (OpenApi.Types.decodeOr OpenApi.Types.decodeExample))
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
                        decodeHeader

                    "path" ->
                        decodePath

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


decodeHeader : Decoder ( Location, Bool )
decodeHeader =
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


decodePath : Decoder ( Location, Bool )
decodePath =
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
