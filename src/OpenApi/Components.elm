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
import OpenApi.Types exposing (Example, Header, Parameter, Path, ReferenceOr(..), RequestBody(..))



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
    , callbacks : Dict String (ReferenceOr ())
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
        |> decodeOptionalDict "schemas" OpenApi.Schema.decode
        |> decodeOptionalDict "responses" (OpenApi.Types.decodeRefOr OpenApi.Response.decode)
        |> decodeOptionalDict "parameters" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeParameter)
        |> decodeOptionalDict "examples" (OpenApi.Types.decodeRefOr OpenApi.Example.decode)
        |> decodeOptionalDict "requestBodies" (OpenApi.Types.decodeRefOr OpenApi.RequestBody.decode)
        |> decodeOptionalDict "headers" (OpenApi.Types.decodeRefOr OpenApi.Types.decodeHeader)
        |> decodeOptionalDict "securitySchemes" (OpenApi.Types.decodeRefOr OpenApi.SecurityScheme.decode)
        |> decodeOptionalDict "links" (OpenApi.Types.decodeRefOr OpenApi.Link.decode)
        |> decodeOptionalDict "callbacks" (OpenApi.Types.decodeRefOr (Debug.todo ""))
        |> decodeOptionalDict "pathItems" (OpenApi.Types.decodeRefOr OpenApi.Types.decodePath)


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
callbacks : Components -> Dict String (ReferenceOr ())
callbacks (Components contact) =
    contact.callbacks


{-| -}
pathItems : Components -> Dict String (ReferenceOr Path)
pathItems (Components contact) =
    contact.pathItems
