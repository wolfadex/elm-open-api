module OpenApi.Components exposing
    ( Components
    , decode
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


## Types

@docs Components


## Decoding

@docs decode


## Querying

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
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline
import OpenApi.Example
import OpenApi.Link exposing (Link)
import OpenApi.RequestBody
import OpenApi.Response exposing (Response)
import OpenApi.Schema exposing (Schema)
import OpenApi.SecurityScheme exposing (SecurityScheme)
import OpenApi.Types exposing (Example, ReferenceOr(..), RequestBody(..))



-- Types


{-| -}
type Components
    = Components Internal


type alias Internal =
    { schemas : Dict String Schema
    , responses : Dict String (ReferenceOr Response)
    , parameters : Dict String (ReferenceOr ())
    , examples : Dict String (ReferenceOr Example)
    , requestBodies : Dict String (ReferenceOr RequestBody)
    , headers : Dict String (ReferenceOr ())
    , securitySchemes : Dict String (ReferenceOr SecurityScheme)
    , links : Dict String (ReferenceOr Link)
    , callbacks : Dict String (ReferenceOr ())
    , pathItems : Dict String (ReferenceOr ())
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
        |> decodeOptionalDict "schemas" OpenApi.Schema.decode
        |> decodeOptionalDict "responses" (OpenApi.Types.decodeOr OpenApi.Response.decode)
        |> decodeOptionalDict "parameters" (OpenApi.Types.decodeOr (Debug.todo ""))
        |> decodeOptionalDict "examples" (OpenApi.Types.decodeOr OpenApi.Example.decode)
        |> decodeOptionalDict "requestBodies" (OpenApi.Types.decodeOr OpenApi.RequestBody.decode)
        |> decodeOptionalDict "headers" (OpenApi.Types.decodeOr (Debug.todo ""))
        |> decodeOptionalDict "securitySchemes" (OpenApi.Types.decodeOr OpenApi.SecurityScheme.decode)
        |> decodeOptionalDict "links" (OpenApi.Types.decodeOr OpenApi.Link.decode)
        |> decodeOptionalDict "callbacks" (OpenApi.Types.decodeOr (Debug.todo ""))
        |> decodeOptionalDict "pathItems" (OpenApi.Types.decodeOr (Debug.todo ""))


decodeOptionalDict : String -> Decoder a -> Decoder (Dict String a -> b) -> Decoder b
decodeOptionalDict field decoder =
    Json.Decode.Pipeline.optional field (Json.Decode.dict decoder) Dict.empty



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
parameters : Components -> Dict String (ReferenceOr ())
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
headers : Components -> Dict String (ReferenceOr ())
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
callbacks : Components -> Dict String (ReferenceOr ())
callbacks (Components contact) =
    contact.callbacks


{-| -}
pathItems : Components -> Dict String (ReferenceOr ())
pathItems (Components contact) =
    contact.pathItems
