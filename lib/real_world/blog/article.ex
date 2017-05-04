defmodule RealWorld.Blog.Article do
  use Ecto.Schema

  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :slug, :string

    timestamps inserted_at: :created_at
  end
end
