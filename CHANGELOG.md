# Change log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## (unreleased) 1.0.1

### Updates to Elixir, Erlang and deps

- elixir 1.8.1
  - erlang 20.0
  - Circle CI config for elixir 1.8.1
- Phoenix v1.3 -> v1.4
  - Refactoring of several modules
  - References:
    - https://www.phoenixdiff.org/?source=1.3.0&target=1.4.3
    - https://github.com/phoenixframework/phoenix/blob/v1.4/CHANGELOG.md
- Ecto v2 -> v3
  - This upgrade includes the split into Ecto + Ecto_sql
- Comeonin v4 -> v5
  - Comeonin changed how dependencies works
  - basically we removed comeonein deps and function calls and replaced it with BCrypt ones
  - Reference: https://github.com/riverrun/comeonin/blob/master/UPGRADE_v5.md

## [1.0.0] - 2019-04-10

### Semantic Versioning & Releases

Started using the following in this project:
- Semantic Versioning
- Git tags
- Github Releases
- CHANGELOG.md

