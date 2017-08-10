defmodule RealWorldWeb.UserView do
  use RealWorldWeb, :view
  alias RealWorldWeb.{UserView, FormatHelpers}

  def render("author.json", %{user: user}) do
    user
    |> Map.from_struct
    |> Map.take([:username, :bio, :image])
  end

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json"),
      usersCount: length(users)}
  end

  def render("show.json", %{jwt: jwt, user: user}) do
    %{user: Map.merge(render_one(user, UserView, "user.json"), %{token: jwt})}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("login.json", %{jwt: jwt, user: user}) do
    %{user: Map.merge(render_one(user, UserView, "user.json"), %{token: jwt})}
  end

  def render("error.json", %{message: message}) do
    %{message: message}
   end

  def render("user.json", %{user: user}) do
    user
    |> Map.from_struct
    |> Map.put(:created_at, NaiveDateTime.to_iso8601(user.created_at))
    |> Map.put(:updated_at, NaiveDateTime.to_iso8601(user.updated_at))
    |> Map.take([:id, :email, :username, :image, :bio, :token, :created_at, :updated_at])
    |> FormatHelpers.camelize
  end

end
