defmodule RealWorld.FavoriteFactory do
  alias RealWorld.Blog.Favorite

  defmacro __using__(_opts) do
    quote do
      def favorite_factory do
        %Favorite{
          user: build(:user),
          article: build(:article)
        }
      end
    end
  end
end
