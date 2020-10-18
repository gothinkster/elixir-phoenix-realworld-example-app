defmodule RealWorldWeb.SessionControllerTest do
  @moduledoc false
  use RealWorldWeb.ConnCase

  @user_default_attrs %{
    email: "john@jacob.com",
    username: "john",
    password: "some password",
    bio: "some bio",
    image: "some image"
  }
  @user_login_attrs %{email: "john@jacob.com", password: "some password"}

  def fixture(:user) do
    {:ok, user} = RealWorld.Accounts.Auth.register(@user_default_attrs)
    user
  end

  def secure_conn(conn) do
    user = fixture(:user)
    {:ok, jwt, _} = user |> RealWorldWeb.Guardian.encode_and_sign(%{}, token_type: :token)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token " <> jwt)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post(secure_conn(conn), Routes.session_path(conn, :create), user: @user_login_attrs)
    json = json_response(conn, 201)["user"]

    assert json == %{
             "id" => json["id"],
             "email" => "john@jacob.com",
             "username" => "john",
             "token" => json["token"],
             "image" => "some image",
             "bio" => "some bio",
             "createdAt" => json["createdAt"],
             "updatedAt" => json["updatedAt"]
           }
  end
end
