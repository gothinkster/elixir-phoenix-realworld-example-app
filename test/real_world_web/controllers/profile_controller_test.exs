defmodule RealWorldWeb.ProfileControllerTest do
  @moduledoc false
  use RealWorldWeb.ConnCase

  @user1_attrs %{
    email: "john@jacob.com",
    username: "john",
    password: "some password",
    bio: "some bio",
    image: "some image"
  }
  @user2_attrs %{
    email: "rick@jacob.com",
    username: "rick",
    password: "some other password",
    bio: "rick bio",
    image: "rick image"
  }

  def fixture(:user1) do
    {:ok, user} = RealWorld.Accounts.Auth.register(@user1_attrs)
    user
  end

  def fixture(:user2) do
    {:ok, user} = RealWorld.Accounts.Auth.register(@user2_attrs)
    user
  end

  def secure_conn(conn) do
    user = fixture(:user1)
    {:ok, jwt, _} = user |> RealWorldWeb.Guardian.encode_and_sign(%{}, token_type: :token)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token " <> jwt)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "return valid profile and following:nil if disconnected", %{conn: conn} do
    user1 = fixture(:user1)
    conn = get(conn, Routes.profile_path(conn, :show, user1.username))
    json = json_response(conn, 200)["profile"]

    assert json == %{
             "username" => user1.username,
             "image" => user1.image,
             "bio" => user1.bio,
             "following" => nil
           }
  end

  test "return valid profile and following:false if connected", %{conn: conn} do
    user2 = fixture(:user2)
    conn = get(secure_conn(conn), Routes.profile_path(conn, :show, user2.username))
    json = json_response(conn, 200)["profile"]

    assert json == %{
             "username" => user2.username,
             "image" => user2.image,
             "bio" => user2.bio,
             "following" => false
           }
  end

  test "follow endpoint is only reachable if connected", %{conn: conn} do
    user2 = fixture(:user2)
    conn = post(conn, Routes.profile_path(conn, :follow, user2.username))
    json = json_response(conn, 403)

    assert json == %{
             "message" => "Not Authenticated"
           }
  end

  test "unfollow endpoint is only reachable if connected", %{conn: conn} do
    user2 = fixture(:user2)
    conn = post(conn, Routes.profile_path(conn, :follow, user2.username))
    json = json_response(conn, 403)

    assert json == %{
             "message" => "Not Authenticated"
           }
  end

  test "set following to true if follow user", %{conn: conn} do
    user2 = fixture(:user2)
    conn = post(secure_conn(conn), Routes.profile_path(conn, :follow, user2.username))
    json = json_response(conn, 200)["profile"]

    assert json == %{
             "username" => user2.username,
             "image" => user2.image,
             "bio" => user2.bio,
             "following" => true
           }
  end

  test "set following to false if unfollow user", %{conn: conn} do
    new_conn = secure_conn(conn)
    user2 = fixture(:user2)

    conn = post(new_conn, Routes.profile_path(conn, :follow, user2.username))
    json = json_response(conn, 200)["profile"]

    assert json == %{
             "username" => user2.username,
             "image" => user2.image,
             "bio" => user2.bio,
             "following" => true
           }

    conn = delete(new_conn, Routes.profile_path(conn, :unfollow, user2.username))
    json = json_response(conn, 200)["profile"]

    assert json == %{
             "username" => user2.username,
             "image" => user2.image,
             "bio" => user2.bio,
             "following" => false
           }
  end
end
