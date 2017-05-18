defmodule RealWorld.GuardianSerializer do
  @moduledoc """
  Used by Guardian to serialize JWT token
  """
  @behaviour Guardian.Serializer

  alias RealWorld.{Repo, Accounts.User}

  def for_token(%User{} = user), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
