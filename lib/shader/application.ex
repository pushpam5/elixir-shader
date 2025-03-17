defmodule Shader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShaderWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:shader, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Shader.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Shader.Finch},
      # Start a worker by calling: Shader.Worker.start_link(arg)
      # {Shader.Worker, arg},
      # Start to serve requests, typically the last entry
      ShaderWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shader.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShaderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
