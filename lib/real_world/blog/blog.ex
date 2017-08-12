defmodule RealWorld.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  import Ecto.Query, warn: false
  alias RealWorld.Repo
  alias RealWorld.Blog.Article

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(Article)
  end

  def list_tags do
    Ecto.Adapters.SQL.query!(Repo, "select count(*) as tag_count, ut.tag
          from articles, lateral unnest(articles.tag_list) as ut(tag)
          group by ut.tag
          order by tag_count desc limit 5;").rows
          |> Enum.map(fn(v) -> Enum.at(v, 1) end)
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id)

  def get_article_by_slug!(slug), do: Repo.get_by!(Article, slug: slug)

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(slug) do
    case Article |> Repo.get_by(slug: slug) do
      nil ->
        false
      article ->
        Repo.delete(article)
    end
  end


end
