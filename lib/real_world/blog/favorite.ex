defmodule RealWorld.Blog.Favorite do
  @moduledoc """
  The Favorite Model
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias RealWorld.Accounts.User
  alias RealWorld.Blog.{Article, Favorite}

  @required_fields ~w(user_id article_id)a

  schema "favorites" do
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :article, Article, foreign_key: :article_id

    timestamps()
  end

  @doc false
  def changeset(%Favorite{} = favorite, attrs) do
    favorite
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
