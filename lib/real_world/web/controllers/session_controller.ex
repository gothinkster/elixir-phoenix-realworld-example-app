defmodule RealWorld.Web.SessionController do
  use RealWorld.Web, :controller

  alias RealWorld.Accounts.Auth

  action_fallback RealWorld.Web.FallbackController

  def create(conn, params) do
    case Auth.find_user_and_check_password(params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)

        conn
        |> put_status(:created)
        |> render(RealWorld.Web.UserView, "login.json", jwt: jwt, user: user)
      {:error, message} ->
        conn
        |> put_status(401)
        |> render(RealWorld.Web.UserView, "error.json", message: message)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(RealWorld.Web.UserView, "error.json", message: "Not Authenticated")
  end


end
