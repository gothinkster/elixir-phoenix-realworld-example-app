defmodule RealWorldWeb.SessionController do
  use RealWorldWeb, :controller

  alias RealWorld.Accounts.Auth

  action_fallback(RealWorldWeb.FallbackController)

  def create(conn, params) do
    case Auth.find_user_and_check_password(params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =
          user |> RealWorldWeb.Guardian.encode_and_sign(%{}, token_type: :token)

        conn
        |> put_status(:created)
        |> put_view(RealWorldWeb.UserView)
        |> render("login.json", jwt: jwt, user: user)

      {:error, message} ->
        conn
        |> put_status(401)
        |> put_view(RealWorldWeb.UserView)
        |> render("error.json", message: message)
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:forbidden)
    |> put_view(RealWorldWeb.UserView)
    |> render("error.json", message: "Not Authenticated")
  end
end
