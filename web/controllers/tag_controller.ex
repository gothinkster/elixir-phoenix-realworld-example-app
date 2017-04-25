defmodule RealWorld.TagController do
  use RealWorld.Web, :controller

  def index(conn, _params) do
    json conn, []
  end
end
