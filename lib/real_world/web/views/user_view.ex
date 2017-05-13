defmodule RealWorld.Web.UserView do
  use RealWorld.Web, :view
  alias RealWorld.Web.{FormatHelpers}

  def render("author.json", %{user: user}) do
    user
    |> Map.from_struct
    |> Map.take([:username, :bio, :image])
    |> FormatHelpers.camelize
  end

end
