defmodule RealWorldWeb.CommentView do
  use RealWorldWeb, :view
  alias RealWorldWeb.{CommentView, FormatHelpers, UserView}

  def render("index.json", %{comments: comments}) do
    %{comments: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{comment: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    comment
    |> Map.from_struct
    |> Map.put(:created_at, datetime_to_iso8601(comment.created_at))
    |> Map.put(:updated_at, datetime_to_iso8601(comment.updated_at))
    |> Map.take([:id, :body, :author, :article_id, :created_at, :updated_at])
    |> Map.put(:author, UserView.render("author.json", user: comment.author))
    |> FormatHelpers.camelize
  end

  defp datetime_to_iso8601(datetime) do
    datetime
    |> Map.put(:microsecond, {elem(datetime.microsecond, 0), 3})
    |> DateTime.to_iso8601
  end
end