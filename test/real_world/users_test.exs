defmodule RealWorld.Accounts.UsersTest do
  @moduledoc nil

  use RealWorld.DataCase

  alias RealWorld.Accounts.Users

  @user_create_attrs %{
    email: "some email",
    password: "some password",
    username: "some username",
    bio: "some bio",
    image: "some image"
  }

  test "update_user/2 hashes the password if new one set" do
    {:ok, user} = RealWorld.Accounts.Auth.register(@user_create_attrs)

    new_password = "newPassword!123"

    Users.update_user(user, %{password: new_password})

    assert RealWorld.Accounts.Auth.find_user_and_check_password(%{
             "user" => %{"email" => @user_create_attrs.email, "password" => new_password}
           })
  end
end
