defmodule RealWorld.Accounts.AuthTest do
  @moduledoc false
  use RealWorld.DataCase

  alias RealWorld.Accounts.Auth
  alias RealWorld.Accounts.User
  alias RealWorld.Repo

  @user_create_attrs %{
    email: "some email",
    password: "some password",
    username: "some username",
    bio: "some bio",
    image: "some image"
  }

  setup do
    Repo.delete_all(User)

    :ok
  end

  test "register/1 creates a user" do
    Auth.register(@user_create_attrs)
  end

  test "register/1 returns error if email is used already" do
    Auth.register(@user_create_attrs)
    assert {:error, _} = Auth.register(@user_create_attrs)
  end
end
