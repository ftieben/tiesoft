defmodule Tiesoft.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TiesoftWeb.Telemetry,
      Tiesoft.Repo,
      {DNSCluster, query: Application.get_env(:tiesoft, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tiesoft.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tiesoft.Finch},
      # Start a worker by calling: Tiesoft.Worker.start_link(arg)
      # {Tiesoft.Worker, arg},
      # Start to serve requests, typically the last entry
      TiesoftWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tiesoft.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TiesoftWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
