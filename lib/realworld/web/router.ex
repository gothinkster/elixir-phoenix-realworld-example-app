defmodule RealWorld.Web.Router do
  use RealWorld.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RealWorld.Web do
    pipe_through :api
  end
end
