defmodule RealWorld.Accounts.UserFollower do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(user_id followee_id)a

  schema "user_followers" do
    field(:user_id, :integer, primary_key: true)
    field(:followee_id, :integer, primary_key: true)

    timestamps(updated_at: false, inserted_at: :created_at, type: :utc_datetime_usec)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:follow, name: :user_followers_pkey)
  end
end
