defmodule RealWorld.AuthTest do
  @moduledoc false
  use RealWorld.DataCase
  import RealWorld.Factory

  alias RealWorld.Accounts.User
  alias RealWorld.Auth

  setup do
    user_params = params_for(:user)
    {:ok, %User{} = user} = Auth.register(user_params)

    {:ok, user: user, user_params: user_params}
  end

  describe "register/1" do
    test "creates a user", %{user: user, user_params: user_params} do
      assert user.username == user_params.username
      assert user.email == user_params.email
      assert user.image == user_params.image
      assert user.bio == user_params.bio
    end

    test "returns error when email params does not exist", %{user_params: user_params} do
      assert {:error, %Ecto.Changeset{} = changeset} =
               user_params
               |> Map.delete(:email)
               |> Auth.register()

      assert "can't be blank" in errors_on(changeset).email
    end

    test "returns error when username params does not exist", %{user_params: user_params} do
      assert {:error, %Ecto.Changeset{} = changeset} =
               user_params
               |> Map.delete(:username)
               |> Auth.register()

      assert "can't be blank" in errors_on(changeset).username
    end

    test "register/1 returns error if username is used already", %{user_params: user_params} do
      assert {:error, %Ecto.Changeset{} = changeset} = Auth.register(user_params)

      assert "has already been taken" in errors_on(changeset).username
    end

    test "register/1 returns error if email is used already", %{user_params: user_params} do
      assert {:error, %Ecto.Changeset{} = changeset} =
               user_params
               |> Map.put(:username, "another name")
               |> Auth.register()

      assert "has already been taken" in errors_on(changeset).email
    end
  end

  describe "find_user_and_check_password/1" do
    test "when user found", %{user_params: user_params} do
      assert {:ok, %User{} = user} =
               Auth.find_user_and_check_password(%{
                 "user" => %{"email" => user_params.email, "password" => user_params.password}
               })

      assert user.username == user_params.username
      assert user.email == user_params.email
      assert user.image == user_params.image
      assert user.bio == user_params.bio
    end

    test "when user not found" do
      assert {:error, "Could not login"} ==
               Auth.find_user_and_check_password(%{
                 "user" => %{"email" => "any@mail.com", "password" => "any passwd"}
               })
    end
  end
end
