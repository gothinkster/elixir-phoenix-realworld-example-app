defmodule RealWorld.Blog.Article do
  use Ecto.Schema

  schema "blog_articles" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :slug, :string
    field :favorites_count, :integer, default: 0

    timestamps()
  end
end
