defmodule RealWorld.UsersTest do
  use RealWorld.DataCase

  alias RealWorld.Users

  @user_create_attrs %{email: "some email", password: "some password", username: "some username", bio: "some bio", image: "some image"}
  @user_invalid_attrs %{email: nil, password: nil, username: nil}
  @user_update_attrs %{email: "some updated email", password: "some updated password", username: "some updated username", bio: "some updated bio", image: "some updated image"}

  test "create_user/1 creates a user" do
    Users.create_user(@user_create_attrs)
  end
end
