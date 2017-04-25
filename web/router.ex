defmodule RealWorld.Router do
  use RealWorld.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RealWorld do
    pipe_through :api

    get "/tags", TagController, :index
  end
end
