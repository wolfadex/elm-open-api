module OpenApi.Reference exposing
    ( Reference
    , ReferenceOr(..)
    , decode
    , decodeOr
    , description
    , ref
    , summary
    )

import Json.Decode exposing (Decoder)
import Json.Decode.Extra


type Reference
    = Reference Internal


type alias Internal =
    { ref : String
    , summary : Maybe String
    , description : Maybe String
    }


type ReferenceOr a
    = Ref Reference
    | Other a


decode : Decoder Reference
decode =
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
        , Json.Decode.map Ref decode
        ]


description : Reference -> Maybe String
description (Reference reference) =
    reference.description


ref : Reference -> String
ref (Reference reference) =
    reference.ref


summary : Reference -> Maybe String
summary (Reference reference) =
    reference.summary
