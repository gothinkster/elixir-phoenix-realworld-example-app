defmodule RealWorldWeb.Router do
  use RealWorldWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ProperCase.Plug.SnakeCaseParams
    plug Guardian.Plug.VerifyHeader, realm: "Token"
    plug Guardian.Plug.LoadResource
  end

  scope "/", RealWorldWeb do
    pipe_through :api

    get "/articles/feed", ArticleController, :feed
    resources "/articles", ArticleController, except: [:new, :edit] do
      resources "/comments", CommentController, except: [:new, :edit]
    end 

    #to allow comments_path in test
    resources "/comments", CommentController, except: [:new, :edit]

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
