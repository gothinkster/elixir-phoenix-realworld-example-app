defmodule RealWorld.Accounts.Users do
  @moduledoc """
  The boundry for the Users system
  """

  alias RealWorld.Repo
  alias RealWorld.Accounts.User

  def get_user!(id), do: Repo.get!(User, id)

  def update_user(user, attrs) do
    user
    |> User.user_changeset(attrs)
    |> Repo.update
  end

end
