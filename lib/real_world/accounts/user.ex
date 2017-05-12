defmodule RealWorld.Accounts.User do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string, unique: true
    field :bio, :string
    field :image, :string

    timestamps inserted_at: :created_at
  end

  def user_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email, :bio, :image])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:username, name: :users_username_index)
  end

end
