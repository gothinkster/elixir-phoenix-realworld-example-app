defmodule RealWorld.Web.TagController do
  use RealWorld.Web, :controller

  alias RealWorld.Blog

  action_fallback RealWorld.Web.FallbackController

  def index(conn, _params) do
    render(conn, "index.json", tags: Blog.list_tags())
  end

end
