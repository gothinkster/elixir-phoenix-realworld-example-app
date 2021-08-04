defmodule RealWorld.Auth do
  @moduledoc """
  The boundry for the Auth system
  """

  import Ecto.{Query, Changeset}, warn: false

  alias RealWorld.Repo
  alias RealWorld.Accounts.User
  alias RealWorld.Encryption

  def find_user_and_check_password(%{"user" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "Could not login"}
    end
  end

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Encryption.validate_password(password, user.password)
    end
  end
end
