# ![RealWorld Example App](logo.png)
[![Travis](https://travis-ci.org/lbighetti/elixir-phoenix-realworld.svg)](https://travis-ci.org/lbighetti/elixir-phoenix-realworld)
[![Coverage Status](https://coveralls.io/repos/github/lbighetti/elixir-phoenix-realworld/badge.svg)](https://coveralls.io/github/lbighetti/elixir-phoenix-realworld)

> Elixir (Phoenix) codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld-example-apps) spec and API.


This codebase was created to demonstrate a fully fledged fullstack application built with **Elixir and Phoenix** including CRUD operations, authentication, routing, pagination, and more.

We've gone to great lengths to adhere to the **[credo](https://github.com/rrrene/credo)** community styleguides & best practices.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repo.

## Current Status

- [x] Auth
  - [x] Login
  - [x] Login and remember token
  - [x] Register
  - [x] Current User
  - [x] Update User
- [x] Articles
  - [x] All Articles
  - [x] Articles by Author
  - [x] Articles Favorited by Username
  - [x] Articles by Tag
  - [x] Single Article by Slug
- [ ] Articles with Auth
  - [ ] Feed
  - [x] All Articles
  - [x] Articles by Author
  - [x] Articles Favorited by Username
  - [x] Create Article
  - [x] Delete Article
  - [x] Update Article
  - [ ] Favorite Article
  - [ ] Unfavorite Article
- [x] Comments
  - [x] Create Comment for Article
  - [x] All Comments for Article
  - [x] Delete Comment for Article
- [x] Profiles
  - [x] Profile
  - [x] Follow Profile
  - [x] Unfollow Profile
- [x] Tags
  - [x] All tags

## Getting started

1. Install [phoenix](http://www.phoenixframework.org/docs/installation) as well as all the other dependencies (erlang, elixir, postgresql).
1. Clone the repo.
1. Run the following commands in the project directory:
    - `mix deps.get` to install dependencies.
    - `cp config/dev.exs.example config/dev.exs` and setup with your database credentials.
    - `mix ecto.create` to create the database.
    - `mix ecto.migrate` to run the database migrations.
    - `mix phx.server` to run the application.

## License

MIT © Ezinwa Okpoechi
