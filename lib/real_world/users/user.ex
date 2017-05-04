defmodule RealWorld.Users.User do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string, unique: true
    field :bio, :string
    field :image, :string

    timestamps inserted_at: :created_at
  end
end
