defmodule Realworld.Router do
  use Realworld.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Realworld do
    pipe_through :api

    get "/tags", TagController, :index
  end
end
