defmodule RealWorldWeb.TagController do
  use RealWorldWeb, :controller

  alias RealWorld.Blogs

  action_fallback(RealWorldWeb.FallbackController)

  def index(conn, _params) do
    render(conn, "index.json", tags: Blogs.list_tags())
  end
end
