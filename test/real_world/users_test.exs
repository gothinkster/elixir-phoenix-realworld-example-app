defmodule RealWorld.Accounts.AuthTest do
  @moduledoc false
  use RealWorld.DataCase

  alias RealWorld.Accounts.Auth

  @user_create_attrs %{email: "some email", password: "some password", username: "some username", bio: "some bio", image: "some image"}

  test "register/1 creates a user" do
    Auth.register(@user_create_attrs)
  end
end
