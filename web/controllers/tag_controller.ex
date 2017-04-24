defmodule Realworld.TagController do
  use Realworld.Web, :controller

  def index(conn, _params) do
    json conn, []
  end
end
