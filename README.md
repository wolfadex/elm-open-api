# `replaceme` [![Build Status](https://github.com/replaceme/replaceme/workflows/CI/badge.svg)](https://github.com/replaceme/replaceme/actions?query=branch%3Amain)

## What this repo includes

| What                                                              | Why?                                                                                                                                                                                                          |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| lydell/elm-tooling.json                                           | Install dependencies, cache them for faster GitHub Actions builds.                                                                                                                                            |
| elm-test                                                          | Basic unit testing boilerplate and runs on GitHub Actions.                                                                                                                                                    |
| [`jfmengels/elm-review`](https://github.com/jfmengels/elm-review) | Statically analyzes your code to find unused code, etc.                                                                                                                                                       |
| dillonkearns/elm-publish-action                                   | Publishes your package whenever you bump your package version in elm.json on your default branch (`main` or `master`). It won't publish 1.0.0 for you, but it will release subsequent versions automatically. |

## Checklist

- [ ] Replace this with a nice readme (see this guide for designing Elm packages and writing nice docs/READMEs: <https://github.com/dillonkearns/idiomatic-elm-package-guide>)
- [ ] Find all instances of replaceme in this repo and replace them
- [ ] Publish version 1.0.0 (you have to start at V1 with Elm packages). Run `elm publish` from the root folder of this repo when you're all ready, and it will walk you through the process!
- [ ] Add a file called `LICENSE` to the top-level folder. This is required to publish an Elm package. The most common and recommended license for open source Elm packages is BSD-3.
