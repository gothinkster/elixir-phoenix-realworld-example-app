# ![RealWorld Example App](logo.png)
[![Travis](https://travis-ci.org/lbighetti/elixir-phoenix-realworld.svg?branch=master)](https://travis-ci.org/lbighetti/elixir-phoenix-realworld)
[![Coveralls](https://coveralls.io/repos/github/lbighetti/elixir-phoenix-realworld/badge.svg?branch=master)](https://coveralls.io/github/lbighetti/elixir-phoenix-realworld?branch=master)
[![Ebert](https://ebertapp.io/github/lbighetti/elixir-phoenix-realworld.svg)](https://ebertapp.io/github/lbighetti/elixir-phoenix-realworld)
> Elixir (Phoenix) codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld-example-apps) spec and API.


This codebase was created to demonstrate a fully fledged fullstack application built with **Elixir and Phoenix** including CRUD operations, authentication, routing, pagination, and more.

We've gone to great lengths to adhere to the **[credo](https://github.com/rrrene/credo)** community styleguides & best practices.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repo.


## Getting started

1. Install [phoenix](http://www.phoenixframework.org/docs/installation) as well as all the other dependencies (erlang, elixir, postgresql).
1. Clone the repo.
1. Run the following commands in the project directory:
    - `mix deps.get` to install dependencies.
    - `mix ecto.create` to create the database.
    - `mix ecto.migrate` to run the database migrations.
    - `mix phx.server` to run the application.

## License

MIT © Ezinwa Okpoechi
