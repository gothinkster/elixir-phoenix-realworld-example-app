defmodule RealWorld.Blog.Article do
  @moduledoc """
  The Article Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]
  @required_fields ~w(title description body user_id)a
  @optional_fields ~w(slug tag_list)a

  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :slug, :string
    field :tag_list, {:array, :string}

    belongs_to :author, RealWorld.Accounts.User, foreign_key: :user_id

    timestamps inserted_at: :created_at
  end


  def changeset(%RealWorld.Blog.Article{} = article, attrs) do
    article
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:author)
    |> unique_constraint(:slug, name: :articles_slug_index)
    |> slugify_title()
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

end
