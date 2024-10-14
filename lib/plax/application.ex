defmodule Plax.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlaxWeb.Telemetry,
      Plax.Repo,
      {DNSCluster, query: Application.get_env(:plax, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Plax.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Plax.Finch},
      # Start a worker by calling: Plax.Worker.start_link(arg)
      # {Plax.Worker, arg},
      # Start to serve requests, typically the last entry
      PlaxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plax.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlaxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
