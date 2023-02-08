module OpenApi.Schema exposing
    ( Schema
    , decode
    , get
    )

import Json.Decode exposing (Decoder, Value)
import Json.Schema.Definitions
import OpenApi.Types exposing (Discriminator, ExternalDocumentation, Schema(..), Xml)


type alias Schema =
    OpenApi.Types.Schema


decode : Decoder Schema
decode =
    OpenApi.Types.decodeSchema


get : Schema -> Json.Schema.Definitions.Schema
get (Schema schema_) =
    schema_



-- discriminator : Schema -> Maybe Discriminator
-- discriminator (Schema schema) =
--     schema.discriminator
-- xml : Schema -> Maybe Xml
-- xml (Schema schema) =
--     schema.xml
-- externalDocs : Schema -> Maybe ExternalDocumentation
-- externalDocs (Schema schema) =
--     schema.externalDocs
-- example : Schema -> Maybe Value
-- example (Schema schema) =
--     schema.example
