defmodule RealWorldWeb.TagControllerTest do
  use RealWorldWeb.ConnCase
  import RealWorld.Factory

  setup do
    user = insert(:user)
    insert(:article, author: user)
    :ok
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, tag_path(conn, :index))
    assert json_response(conn, 200)["tags"] == ["tag1", "tag2"]
  end
end
