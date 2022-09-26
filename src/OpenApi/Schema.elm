module OpenApi.Schema exposing
    ( Schema
    ,  decode
       -- , discriminator
       -- , example
       -- , externalDocs
       -- , xml

    )

import Json.Decode exposing (Decoder, Value)
import OpenApi.Header exposing (schema)
import OpenApi.Types exposing (Discriminator, ExternalDocumentation, Schema(..), Xml)


type alias Schema =
    OpenApi.Types.Schema


decode : Decoder Schema
decode =
    OpenApi.Types.decodeSchema



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
