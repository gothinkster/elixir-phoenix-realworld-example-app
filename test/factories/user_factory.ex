defmodule RealWorld.UserFactory do
  @moduledoc false

  alias RealWorld.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: "john@jacob.com",
          username: "john",
          password: "some password",
          bio: "some bio",
          image: "some image"
        }
      end
    end
  end
end
