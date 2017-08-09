defmodule RealWorldWeb.UserControllerTest do
  @moduledoc false
  use RealWorldWeb.ConnCase

  @user_default_attrs %{email: "john@jacob.com", username: "john", password: "some password", bio: "some bio", image: "some image"}
  @user_create_attrs %{email: "john@jacob.com", username: "john", password: "some password", bio: "some bio", image: "some image"}
  @user_update_attrs %{email: "john11@jacob.com"}

  def fixture(:user) do
    {:ok, user} = RealWorld.Accounts.Auth.register(@user_default_attrs)
    user
  end

  def secure_conn(conn) do
    user = fixture(:user)
    {:ok, jwt, _} = user |> Guardian.encode_and_sign(:token)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token " <> jwt)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @user_create_attrs
    json = json_response(conn, 201)["user"]

    assert json == %{
      "id" => json["id"],
      "email" => "john@jacob.com",
      "username" => "john",
      "token" => json["token"],
      "image" => "some image",
      "bio" => "some bio",
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"]}
  end

  test "view current_user data", %{conn: conn} do
    conn = get secure_conn(conn), user_path(conn, :current_user)
    json = json_response(conn, 200)["user"]

    assert json == %{
      "id" => json["id"],
      "email" => @user_default_attrs.email,
      "username" => @user_default_attrs.username,
      "token" => json["token"],
      "image" => @user_default_attrs.image,
      "bio" => @user_default_attrs.bio,
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"]}
  end

  test "update current_user data", %{conn: conn} do
    conn = put secure_conn(conn), user_path(conn, :update), user: @user_update_attrs
    json = json_response(conn, 200)["user"]

    assert json == %{
      "id" => json["id"],
      "email" => @user_update_attrs.email,
      "username" => @user_default_attrs.username,
      "token" => json["token"],
      "image" => @user_default_attrs.image,
      "bio" => @user_default_attrs.bio,
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"]}
  end

end
