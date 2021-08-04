defmodule RealWorld.Accounts.User do
  @moduledoc """
  The User model.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias RealWorld.Blog.{Article, Comment}
  alias RealWorld.Encryption

  @required_fields ~w(email username password)a
  @optional_fields ~w(bio image)a

  schema "users" do
    field(:email, :string, unique: true)
    field(:password, :string)
    field(:username, :string, unique: true)
    field(:bio, :string)
    field(:image, :string)

    has_many(:articles, Article)
    has_many(:comments, Comment)

    timestamps(inserted_at: :created_at)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> hash_password()
    |> unique_constraint(:username, name: :users_username_index)
    |> unique_constraint(:email)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Encryption.password_hashing(pass))

      _ ->
        changeset
    end
  end
end
