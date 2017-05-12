defmodule RealWorld.Blog.Article do
  @moduledoc """
  The Article Model
  """

  use Ecto.Schema

  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :slug, :string

    timestamps inserted_at: :created_at
  end
end
