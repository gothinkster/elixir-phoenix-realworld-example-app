defmodule RealWorld.Users do
  @moduledoc """
  The boundry for the User system
  """

  import Ecto.{Query, Changeset}, warn: false
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias RealWorld.Repo
  alias RealWorld.Users.User

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> hash_password
    |> Repo.insert
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:username, name: :unq_index_accounts_users_username)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
