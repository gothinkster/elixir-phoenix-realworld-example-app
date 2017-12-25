defmodule RealWorldWeb.ProfileController do
  use RealWorldWeb, :controller
  use RealWorldWeb.GuardedController

  alias RealWorld.Accounts.{Users, User}

  action_fallback RealWorldWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated when action in [:follow, :unfollow]

  def show(conn, %{"username" => username}, current_user) do
    case Users.get_by_username(username) do
      user = %User{} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user, following: Users.is_following?(current_user, user))
      nil ->
        conn
        |> put_status(:not_found)
        |> render(RealWorldWeb.ErrorView, "404.json")
    end
  end

  def follow(conn, %{"username" => username}, current_user) do
    case Users.get_by_username(username) do
      followee = %User{} ->
        current_user
        |> Users.follow(followee)

        conn
        |> put_status(:ok)
        |> render("show.json", user: followee, following: Users.is_following?(current_user, followee))
      nil ->
        conn
        |> put_status(:not_found)
        |> render(RealWorldWeb.ErrorView, "404.json")
    end
  end

  def unfollow(conn, %{"username" => username}, current_user) do
    case Users.get_by_username(username) do
      followee = %User{} ->
        current_user
        |> Users.unfollow(followee)

        conn
        |> put_status(:ok)
        |> render("show.json", user: followee, following: Users.is_following?(current_user, followee))
      nil ->
        conn
        |> put_status(:not_found)
        |> render(RealWorldWeb.ErrorView, "404.json")
    end
  end

end
