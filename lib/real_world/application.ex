defmodule RealWorld.Application do
  @moduledoc false
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      RealWorld.Repo,
      # Start the endpoint when the application starts
      RealWorldWeb.Endpoint
      # Starts a worker by calling: RealWorld.Worker.start_link(arg)
      # {RealWorld.Worker, arg},
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RealWorld.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RealWorldWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
