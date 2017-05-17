defmodule RealWorld.Accounts.Users do
  @moduledoc """
  The boundry for the Users system
  """

  alias RealWorld.Repo
  alias RealWorld.Accounts.User
  alias RealWorld.Accounts.UserFollower

  def get_user!(id), do: Repo.get!(User, id)
  def get_by_username(username), do: Repo.get_by(User, username: username)

  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update
  end

  def follow(user, follower) do
    %UserFollower{}
    |> UserFollower.changeset(%{user_id: user.id, follower_id: follower.id})
    |> Repo.insert()
  end

  def unfollow(user, follower) do
    relation = UserFollower
    |> Repo.get_by(user_id: user.id, follower_id: follower.id)

    case relation do
      nil ->
        false
      relation ->
        Repo.delete(relation)
    end
  end

  def is_following?(user, follower) do
    cond do
      user != nil && follower != nil ->
        (UserFollower |> Repo.get_by(user_id: user.id, follower_id: follower.id)) != nil
      true ->
        nil
    end
  end

end
