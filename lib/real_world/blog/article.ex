defmodule RealWorld.Blog.Article do
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :slug, :string
    field :tag_list, {:array, :string}

    belongs_to :author, RealWorld.Users.User, foreign_key: :user_id

    timestamps inserted_at: :created_at
  end
end
