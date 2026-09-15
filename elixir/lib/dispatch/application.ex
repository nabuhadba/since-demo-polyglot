defmodule Dispatch.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children =
      if Application.get_env(:dispatch, :start_server, true) do
        [{Plug.Cowboy, scheme: :http, plug: DispatchWeb.Router, options: [port: Application.fetch_env!(:dispatch, :port)]}]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: Dispatch.Supervisor)
  end
end
