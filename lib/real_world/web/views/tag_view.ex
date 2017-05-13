defmodule RealWorld.Web.TagView do
  use RealWorld.Web, :view

  def render("index.json", %{tags: tags}) do
    %{tags: tags}
  end

end
