defmodule RealWorld.ArticleFactory do
  @moduledoc false

  alias RealWorld.Blog.Article

  defmacro __using__(_opts) do
    quote do
      def article_factory do
        %Article{
          body: "some body",
          description: "some description",
          title: "some title",
          tag_list: ["tag1", "tag2"],
          slug: sequence(:slug, &"some-tile-#{&1}"),
          author: build(:user)
        }
      end
    end
  end
end
