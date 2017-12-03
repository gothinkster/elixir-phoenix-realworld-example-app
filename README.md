# ![RealWorld Example App](logo.png)

> Elixir (Phoenix) codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld-example-apps) spec and API.

This codebase was created to demonstrate a fully fledged fullstack application built with **Elixir and Phoenix** including CRUD operations, authentication, routing, pagination, and more.

We've gone to great lengths to adhere to the **[credo](https://github.com/rrrene/credo)** community styleguides & best practices.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repo.

## Getting started

1. Install [phoenix](http://www.phoenixframework.org/docs/installation) as well as all the other dependencies (erlang, elixir, postgresql).
1. Clone the repo.
1. Run the following commands in the project directory:
    - `cp config/dev.exs.example config/dev.exs` and setup with your database credentials.
    - `mix deps.get` to install dependencies.
    - `mix ecto.create` to create the database.
    - `mix ecto.migrate` to run the database migrations.
    - `mix phx.server` to run the application.

## License

MIT © Ezinwa Okpoechi
