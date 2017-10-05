defmodule RealWorld.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealWorld.Blog.Comment
  alias RealWorld.Blog.Article
  alias RealWorld.Accounts.User

  @timestamps_opts [type: :utc_datetime]
  @required_fields ~w(body user_id article_id)a
  #@optional_fields ~w(slug tag_list)a


  schema "comments" do
    field :body, :string

    belongs_to :article, Article, foreign_key: :article_id
    belongs_to :author, User, foreign_key: :user_id
    timestamps inserted_at: :created_at
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, @required_fields)
    |> validate_required([:body])
    |> assoc_constraint(:author)
  end
end
