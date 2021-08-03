defmodule RealWorld.CommentFactory do
  alias RealWorld.Blog.Comment

  defmacro __using__(_opts) do
    quote do
      def comment_factory do
        %Comment{
          body: "some body",
          author: build(:user)
        }
      end
    end
  end
end
