module Test.ApiWithExamples exposing (suite)

import Expect
import Json.Decode
import OpenApi
import Semver
import Test exposing (..)


suite : Test
suite =
    describe "Decodes an API with examples"
        (let
            decodedOas =
                Json.Decode.decodeString OpenApi.decode jsonString
         in
         [ test "Decodes the version" <|
            \() ->
                decodedOas
                    |> Result.map (OpenApi.version >> Semver.print)
                    |> Expect.equal (Ok "3.0.0")
         , test "Failes if the version is missing" <|
            \() ->
                Json.Decode.decodeString OpenApi.decode """{ "name": "carl" }"""
                    |> Expect.err
         , test "Decodes the info object" <|
            \() ->
                decodedOas
                    |> Result.map OpenApi.info
                    |> Expect.ok
         , test "Decodes the paths" <|
            \() ->
                decodedOas
                    |> Result.map OpenApi.paths
                    |> Expect.ok
         ]
        )


jsonString : String
jsonString =
    """{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API overview",
    "version": "2.0.0"
  },
  "paths": {
    "/": {
      "get": {
        "operationId": "listVersionsv2",
        "summary": "List API versions",
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "examples": {
                  "foo": {
                    "value": {
                      "versions": [
                        {
                          "status": "CURRENT",
                          "updated": "2011-01-21T11:33:21Z",
                          "id": "v2.0",
                          "links": [
                            {
                              "href": "http://127.0.0.1:8774/v2/",
                              "rel": "self"
                            }
                          ]
                        },
                        {
                          "status": "EXPERIMENTAL",
                          "updated": "2013-07-23T11:33:21Z",
                          "id": "v3.0",
                          "links": [
                            {
                              "href": "http://127.0.0.1:8774/v3/",
                              "rel": "self"
                            }
                          ]
                        }
                      ]
                    }
                  }
                }
              }
            }
          },
          "300": {
            "description": "300 response",
            "content": {
              "application/json": {
                "examples": {
                  "foo": {
                    "value": "{\\n \\"versions\\": [\\n       {\\n         \\"status\\": \\"CURRENT\\",\\n         \\"updated\\": \\"2011-01-21T11:33:21Z\\",\\n         \\"id\\": \\"v2.0\\",\\n         \\"links\\": [\\n             {\\n                 \\"href\\": \\"http://127.0.0.1:8774/v2/\\",\\n                 \\"rel\\": \\"self\\"\\n             }\\n         ]\\n     },\\n     {\\n         \\"status\\": \\"EXPERIMENTAL\\",\\n         \\"updated\\": \\"2013-07-23T11:33:21Z\\",\\n         \\"id\\": \\"v3.0\\",\\n         \\"links\\": [\\n             {\\n                 \\"href\\": \\"http://127.0.0.1:8774/v3/\\",\\n                 \\"rel\\": \\"self\\"\\n             }\\n         ]\\n     }\\n ]\\n}\\n"
                  }
                }
              }
            }
          }
        }
      }
    },
    "/v2": {
      "get": {
        "operationId": "getVersionDetailsv2",
        "summary": "Show API version details",
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "examples": {
                  "foo": {
                    "value": {
                      "version": {
                        "status": "CURRENT",
                        "updated": "2011-01-21T11:33:21Z",
                        "media-types": [
                          {
                            "base": "application/xml",
                            "type": "application/vnd.openstack.compute+xml;version=2"
                          },
                          {
                            "base": "application/json",
                            "type": "application/vnd.openstack.compute+json;version=2"
                          }
                        ],
                        "id": "v2.0",
                        "links": [
                          {
                            "href": "http://127.0.0.1:8774/v2/",
                            "rel": "self"
                          },
                          {
                            "href": "http://docs.openstack.org/api/openstack-compute/2/os-compute-devguide-2.pdf",
                            "type": "application/pdf",
                            "rel": "describedby"
                          },
                          {
                            "href": "http://docs.openstack.org/api/openstack-compute/2/wadl/os-compute-2.wadl",
                            "type": "application/vnd.sun.wadl+xml",
                            "rel": "describedby"
                          },
                          {
                            "href": "http://docs.openstack.org/api/openstack-compute/2/wadl/os-compute-2.wadl",
                            "type": "application/vnd.sun.wadl+xml",
                            "rel": "describedby"
                          }
                        ]
                      }
                    }
                  }
                }
              }
            }
          },
          "203": {
            "description": "203 response",
            "content": {
              "application/json": {
                "examples": {
                  "foo": {
                    "value": {
                      "version": {
                        "status": "CURRENT",
                        "updated": "2011-01-21T11:33:21Z",
                        "media-types": [
                          {
                            "base": "application/xml",
                            "type": "application/vnd.openstack.compute+xml;version=2"
                          },
                          {
                            "base": "application/json",
                            "type": "application/vnd.openstack.compute+json;version=2"
                          }
                        ],
                        "id": "v2.0",
                        "links": [
                          {
                            "href": "http://23.253.228.211:8774/v2/",
                            "rel": "self"
                          },
                          {
                            "href": "http://docs.openstack.org/api/openstack-compute/2/os-compute-devguide-2.pdf",
                            "type": "application/pdf",
                            "rel": "describedby"
                          },
                          {
                            "href": "http://docs.openstack.org/api/openstack-compute/2/wadl/os-compute-2.wadl",
                            "type": "application/vnd.sun.wadl+xml",
                            "rel": "describedby"
                          }
                        ]
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}"""
