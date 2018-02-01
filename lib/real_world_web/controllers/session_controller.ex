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
        |> render(RealWorldWeb.UserView, "login.json", jwt: jwt, user: user)

      {:error, message} ->
        conn
        |> put_status(401)
        |> render(RealWorldWeb.UserView, "error.json", message: message)
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:forbidden)
    |> render(RealWorldWeb.UserView, "error.json", message: "Not Authenticated")
  end
end
