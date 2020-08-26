defmodule RealWorld.Repo do
  use Ecto.Repo,
    otp_app: :real_world,
    adapter: Ecto.Adapters.Mnesia

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
