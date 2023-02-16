# `elm-open-api` [![Build Status](https://github.com/wolfadex/elm-open-api/workflows/CI/badge.svg)](https://github.com/wolfadex/elm-open-api/actions?query=branch%3Amain)

For decoding and querying an OpenAPI Document which conforms to the [OpenAPI Specification](https://www.openapis.org/) (OAS). OAS can be generated from backend REST APIs and are used to define the expected behavior of a RESTful API.

OAS can be written in JSON or YAML; currently this pacakge supports parsing the JSON format only.

There are primarily 2 versions of OAS the current 3.X versions, which this package supports, and the legacy 2.X versions, also known as Swagger or Swagger docs. I hope to support the 2.X, Swagger, spec in a future release as there are still numerous APIs that only support 2.X.

For supported versions I attempt to provide a minimal level of validation of the OAS and parsing may fail if it doesn't meet the minimum requirements. Howver you should not expect that a successfully parsed OAS is 100% compliant. E.g. some fields are required if and only if another specific field is present and has a specific value. These are not always validated to be present in those cases but a best attempt is made.

For documentation on what specific values mean in the context of an OAS, please refer to the [official OAS docs](https://spec.openapis.org/oas/latest).

## Currently Supported & In-Progress Features

🚧 - Under construction

🧪 - Tested

- Versions
  - [ ] 2.x.y
  - [ ] 3.0.y
  - [ ] 🚧 3.1.0
    - [x] 🧪 OpenAPI Object
      - Uses [dividat/elm-semver](https://package.elm-lang.org/packages/dividat/elm-semver/latest/) for SemVer version parsing and
    - [x] 🧪 Info Object
    - [x] 🧪 Contact Object
    - [x] 🧪 License Object
    - [x] 🧪 Server Object
    - [x] 🧪 Server Variable Object
    - [x] 🧪 Components Object
    - [x] 🧪 Paths Object
    - [x] 🧪 Path Item Object
    - [x] 🧪 Operation Object
    - [x] 🧪 External Documentation Object
    - [x] 🧪 Parameter Object
    - [x] 🧪 Request Body Object
    - [x] 🧪 Media Type Object
    - [x] 🧪 Encoding Object
    - [x] 🧪 Responses Object
    - [x] 🧪 Response Object
    - [x] 🧪 Callback Object
    - [x] 🧪 Example Object
    - [x] 🧪 Link Object
    - [x] 🧪 Header Object
    - [x] 🧪 Tag Object
    - [x] 🧪 Reference Object
    - [x] Schema Object
      - Uses [json-tools/json-schema](https://package.elm-lang.org/packages/json-tools/json-schema/latest/)
      - This will stay a separate package as it has its [own, separate specification](https://json-schema.org/specification.html)
    - [x] Discriminator Object
    - [x] XML Object
    - [x] 🧪 Security Scheme Object
    - [x] 🧪 OAuth Flows Object
    - [x] 🧪 OAuth Flow Object
    - [x] 🧪 Security Requirement Object
    - [ ] 🚧 Specification Extensions
    - [ ] 🚧 Security Filtering
