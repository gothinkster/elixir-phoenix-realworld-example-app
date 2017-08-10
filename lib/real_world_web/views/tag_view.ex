defmodule RealWorldWeb.TagView do
  use RealWorldWeb, :view

  def render("index.json", %{tags: tags}) do
    %{tags: tags}
  end

end
