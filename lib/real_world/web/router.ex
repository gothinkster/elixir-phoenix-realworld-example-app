defmodule RealWorld.Web.Router do
  use RealWorld.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ProperCase.Plug.SnakeCaseParams
    plug Guardian.Plug.VerifyHeader, realm: "Token"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", RealWorld.Web do
    pipe_through :api

    resources "/articles", ArticleController, except: [:new, :edit]
    get "/tags", TagController, :index

    get "/user", UserController, :current_user
    put "/user", UserController, :update
    post "/users", UserController, :create
    post "/users/login", SessionController, :create

    get "/profiles/:username", ProfileController, :show
    post "/profiles/:username/follow", ProfileController, :follow
    delete "/profiles/:username/follow", ProfileController, :unfollow
  end
end
