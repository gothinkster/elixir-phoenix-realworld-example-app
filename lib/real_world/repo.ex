defmodule RealWorld.Repo do
  use Ecto.Repo,
    otp_app: :real_world,
    adapter: Ecto.Adapters.Postgres
end
