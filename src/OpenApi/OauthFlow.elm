module OpenApi.OauthFlow exposing
    ( OauthFlows
    , ImplicitFlow
    , PasswordFlow
    , ClientCredentialsFlow
    , AuthorizationCodeFlow
    , decodeFlows, encodeFlows
    , decodeImplicit, encodeImplicit
    , decodePassword, encodePassword
    , decodeClientCredentials, encodeClientCredentials
    , decodeAuthorizationCode, encodeAuthorizationCode
    , implicit
    , password
    , clientCredentials
    , authorizationCode
    , implicitAuthorizationUrl
    , implicitRefreshUrl
    , implicitScopes
    , passwordTokenUrl
    , passwordRefreshUrl
    , passwordScopes
    , clientCredentialTokenUrl
    , clientCredentialRefreshUrl
    , clientCredentialScopes
    , authorizationCodeAuthorizationUrl
    , authorizationCodeTokenUrl
    , authorizationCodeRefreshUrl
    , authorizationCodeScopes
    )

{-| Corresponds to the [OAuth Flows Object](https://spec.openapis.org/oas/latest.html#oauth-flows-object) in the OpenAPI specification, as well as the [OAuth Flow Object](https://spec.openapis.org/oas/latest.html#oauth-flow-object).


# Types

@docs OauthFlows
@docs ImplicitFlow
@docs PasswordFlow
@docs ClientCredentialsFlow
@docs AuthorizationCodeFlow


# Decoding / Encoding

@docs decodeFlows, encodeFlows
@docs decodeImplicit, encodeImplicit
@docs decodePassword, encodePassword
@docs decodeClientCredentials, encodeClientCredentials
@docs decodeAuthorizationCode, encodeAuthorizationCode


# Querying


## OAuth Flows

@docs implicit
@docs password
@docs clientCredentials
@docs authorizationCode


## Implicit Flows

@docs implicitAuthorizationUrl
@docs implicitRefreshUrl
@docs implicitScopes


## Password Flows

@docs passwordTokenUrl
@docs passwordRefreshUrl
@docs passwordScopes


## Client Credential Flows

@docs clientCredentialTokenUrl
@docs clientCredentialRefreshUrl
@docs clientCredentialScopes


## Authorization Code Flows

@docs authorizationCodeAuthorizationUrl
@docs authorizationCodeTokenUrl
@docs authorizationCodeRefreshUrl
@docs authorizationCodeScopes

-}

import Dict exposing (Dict)
import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Encode



-- Types


{-| -}
type OauthFlows
    = OauthFlows InternalFlows


type alias InternalFlows =
    { implicit : Maybe ImplicitFlow
    , password : Maybe PasswordFlow
    , clientCredentials : Maybe ClientCredentialsFlow
    , authorizationCode : Maybe AuthorizationCodeFlow
    }


{-| -}
type ImplicitFlow
    = ImplicitFlow ImplicitFlowInternal


type alias ImplicitFlowInternal =
    { authorizationUrl : String
    , refreshUrl : Maybe String
    , scopes : Dict String String
    }


{-| -}
type PasswordFlow
    = PasswordFlow PasswordFlowInternal


type alias PasswordFlowInternal =
    { tokenUrl : String
    , refreshUrl : Maybe String
    , scopes : Dict String String
    }


{-| -}
type ClientCredentialsFlow
    = ClientCredentialsFlow ClientCredentialsFlowInternal


type alias ClientCredentialsFlowInternal =
    { tokenUrl : String
    , refreshUrl : Maybe String
    , scopes : Dict String String
    }


{-| -}
type AuthorizationCodeFlow
    = AuthorizationCodeFlow AuthorizationCodeFlowInternal


type alias AuthorizationCodeFlowInternal =
    { authorizationUrl : String
    , tokenUrl : String
    , refreshUrl : Maybe String
    , scopes : Dict String String
    }



-- Decoding


{-| -}
decodeFlows : Decoder OauthFlows
decodeFlows =
    Json.Decode.map4
        (\implicit_ password_ clientCredentials_ authorizationCode_ ->
            OauthFlows
                { implicit = implicit_
                , password = password_
                , clientCredentials = clientCredentials_
                , authorizationCode = authorizationCode_
                }
        )
        (Json.Decode.Extra.optionalField "implicit" decodeImplicit)
        (Json.Decode.Extra.optionalField "password" decodePassword)
        (Json.Decode.Extra.optionalField "clientCredentials" decodeClientCredentials)
        (Json.Decode.Extra.optionalField "authorizationCode" decodeAuthorizationCode)


{-| -}
encodeFlows : OauthFlows -> Json.Encode.Value
encodeFlows (OauthFlows oauthFlows) =
    [ Internal.maybeEncodeField ( "implicit", encodeImplicit ) oauthFlows.implicit
    , Internal.maybeEncodeField ( "password", encodePassword ) oauthFlows.password
    , Internal.maybeEncodeField ( "clientCredentials", encodeClientCredentials ) oauthFlows.clientCredentials
    , Internal.maybeEncodeField ( "authorizationCode", encodeAuthorizationCode ) oauthFlows.authorizationCode
    ]
        |> List.filterMap identity
        |> Json.Encode.object


{-| -}
decodeImplicit : Decoder ImplicitFlow
decodeImplicit =
    Json.Decode.map3
        (\authorizationUrl_ refreshUrl_ scopes_ ->
            ImplicitFlow
                { authorizationUrl = authorizationUrl_
                , refreshUrl = refreshUrl_
                , scopes = scopes_
                }
        )
        (Json.Decode.field "authorizationUrl" Json.Decode.string)
        (Json.Decode.Extra.optionalField "refreshUrl" Json.Decode.string)
        (Json.Decode.field "scopes" decodeScopes)


{-| -}
encodeImplicit : ImplicitFlow -> Json.Encode.Value
encodeImplicit (ImplicitFlow implicitFlow) =
    [ Just ( "authorizationUrl", Json.Encode.string implicitFlow.authorizationUrl )
    , Internal.maybeEncodeField ( "refreshUrl", Json.Encode.string ) implicitFlow.refreshUrl
    , Just ( "scopes", encodeScopes implicitFlow.scopes )
    ]
        |> List.filterMap identity
        |> Json.Encode.object


{-| -}
decodePassword : Decoder PasswordFlow
decodePassword =
    Json.Decode.map3
        (\tokenUrl_ refreshUrl_ scopes_ ->
            PasswordFlow
                { tokenUrl = tokenUrl_
                , refreshUrl = refreshUrl_
                , scopes = scopes_
                }
        )
        (Json.Decode.field "tokenUrl" Json.Decode.string)
        (Json.Decode.Extra.optionalField "refreshUrl" Json.Decode.string)
        (Json.Decode.field "scopes" decodeScopes)


{-| -}
encodePassword : PasswordFlow -> Json.Encode.Value
encodePassword (PasswordFlow passwordFlow) =
    [ Just ( "tokenUrl", Json.Encode.string passwordFlow.tokenUrl )
    , Internal.maybeEncodeField ( "refreshUrl", Json.Encode.string ) passwordFlow.refreshUrl
    , Just ( "scopes", encodeScopes passwordFlow.scopes )
    ]
        |> List.filterMap identity
        |> Json.Encode.object


{-| -}
decodeClientCredentials : Decoder ClientCredentialsFlow
decodeClientCredentials =
    Json.Decode.map3
        (\tokenUrl_ refreshUrl_ scopes_ ->
            ClientCredentialsFlow
                { tokenUrl = tokenUrl_
                , refreshUrl = refreshUrl_
                , scopes = scopes_
                }
        )
        (Json.Decode.field "tokenUrl" Json.Decode.string)
        (Json.Decode.Extra.optionalField "refreshUrl" Json.Decode.string)
        (Json.Decode.field "scopes" decodeScopes)


{-| -}
encodeClientCredentials : ClientCredentialsFlow -> Json.Encode.Value
encodeClientCredentials (ClientCredentialsFlow clientCredentialsFlow) =
    [ Just ( "tokenUrl", Json.Encode.string clientCredentialsFlow.tokenUrl )
    , Internal.maybeEncodeField ( "refreshUrl", Json.Encode.string ) clientCredentialsFlow.refreshUrl
    , Just ( "scopes", encodeScopes clientCredentialsFlow.scopes )
    ]
        |> List.filterMap identity
        |> Json.Encode.object


{-| -}
decodeAuthorizationCode : Decoder AuthorizationCodeFlow
decodeAuthorizationCode =
    Json.Decode.map4
        (\authorizationUrl_ tokenUrl_ refreshUrl_ scopes_ ->
            AuthorizationCodeFlow
                { authorizationUrl = authorizationUrl_
                , tokenUrl = tokenUrl_
                , refreshUrl = refreshUrl_
                , scopes = scopes_
                }
        )
        (Json.Decode.field "authorizationUrl" Json.Decode.string)
        (Json.Decode.field "tokenUrl" Json.Decode.string)
        (Json.Decode.Extra.optionalField "refreshUrl" Json.Decode.string)
        (Json.Decode.field "scopes" decodeScopes)


{-| -}
encodeAuthorizationCode : AuthorizationCodeFlow -> Json.Encode.Value
encodeAuthorizationCode (AuthorizationCodeFlow authorizationCodeFlow) =
    [ Just ( "authorizationUrl", Json.Encode.string authorizationCodeFlow.authorizationUrl )
    , Just ( "tokenUrl", Json.Encode.string authorizationCodeFlow.tokenUrl )
    , Internal.maybeEncodeField ( "refreshUrl", Json.Encode.string ) authorizationCodeFlow.refreshUrl
    , Just ( "scopes", encodeScopes authorizationCodeFlow.scopes )
    ]
        |> List.filterMap identity
        |> Json.Encode.object


decodeScopes : Decoder (Dict String String)
decodeScopes =
    Json.Decode.dict Json.Decode.string


encodeScopes : Dict String String -> Json.Encode.Value
encodeScopes =
    Json.Encode.dict identity Json.Encode.string



-- Querying


{-| -}
implicit : OauthFlows -> Maybe ImplicitFlow
implicit (OauthFlows oauthFlows) =
    oauthFlows.implicit


{-| -}
password : OauthFlows -> Maybe PasswordFlow
password (OauthFlows oauthFlows) =
    oauthFlows.password


{-| -}
clientCredentials : OauthFlows -> Maybe ClientCredentialsFlow
clientCredentials (OauthFlows oauthFlows) =
    oauthFlows.clientCredentials


{-| -}
authorizationCode : OauthFlows -> Maybe AuthorizationCodeFlow
authorizationCode (OauthFlows oauthFlows) =
    oauthFlows.authorizationCode


{-| -}
implicitAuthorizationUrl : ImplicitFlow -> String
implicitAuthorizationUrl (ImplicitFlow implicitFlow) =
    implicitFlow.authorizationUrl


{-| -}
implicitRefreshUrl : ImplicitFlow -> Maybe String
implicitRefreshUrl (ImplicitFlow implicitFlow) =
    implicitFlow.refreshUrl


{-| -}
implicitScopes : ImplicitFlow -> Dict String String
implicitScopes (ImplicitFlow implicitFlow) =
    implicitFlow.scopes


{-| -}
passwordTokenUrl : PasswordFlow -> String
passwordTokenUrl (PasswordFlow passwordFlow) =
    passwordFlow.tokenUrl


{-| -}
passwordRefreshUrl : PasswordFlow -> Maybe String
passwordRefreshUrl (PasswordFlow passwordFlow) =
    passwordFlow.refreshUrl


{-| -}
passwordScopes : PasswordFlow -> Dict String String
passwordScopes (PasswordFlow passwordFlow) =
    passwordFlow.scopes


{-| -}
clientCredentialTokenUrl : ClientCredentialsFlow -> String
clientCredentialTokenUrl (ClientCredentialsFlow clientCredentialFlow) =
    clientCredentialFlow.tokenUrl


{-| -}
clientCredentialRefreshUrl : ClientCredentialsFlow -> Maybe String
clientCredentialRefreshUrl (ClientCredentialsFlow clientCredentialFlow) =
    clientCredentialFlow.refreshUrl


{-| -}
clientCredentialScopes : ClientCredentialsFlow -> Dict String String
clientCredentialScopes (ClientCredentialsFlow clientCredentialFlow) =
    clientCredentialFlow.scopes


{-| -}
authorizationCodeAuthorizationUrl : AuthorizationCodeFlow -> String
authorizationCodeAuthorizationUrl (AuthorizationCodeFlow authorizationCodeFlow) =
    authorizationCodeFlow.authorizationUrl


{-| -}
authorizationCodeTokenUrl : AuthorizationCodeFlow -> String
authorizationCodeTokenUrl (AuthorizationCodeFlow authorizationCodeFlow) =
    authorizationCodeFlow.tokenUrl


{-| -}
authorizationCodeRefreshUrl : AuthorizationCodeFlow -> Maybe String
authorizationCodeRefreshUrl (AuthorizationCodeFlow authorizationCodeFlow) =
    authorizationCodeFlow.refreshUrl


{-| -}
authorizationCodeScopes : AuthorizationCodeFlow -> Dict String String
authorizationCodeScopes (AuthorizationCodeFlow authorizationCodeFlow) =
    authorizationCodeFlow.scopes
