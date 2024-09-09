defmodule HelpHero.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HelpHeroWeb.Telemetry,
      HelpHero.Repo,
      {DNSCluster, query: Application.get_env(:help_hero, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelpHero.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HelpHero.Finch},
      # Start a worker by calling: HelpHero.Worker.start_link(arg)
      # {HelpHero.Worker, arg},
      # Start to serve requests, typically the last entry
      HelpHeroWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelpHero.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelpHeroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
