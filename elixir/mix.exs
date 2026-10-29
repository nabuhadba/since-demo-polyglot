defmodule Dispatch.MixProject do
  use Mix.Project

  def project do
    [
      app: :dispatch,
      version: "0.9.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :inets, :ssl],
      mod: {Dispatch.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},
      # plug 1.20+ needs Elixir 1.15; 1.19 is the newest line on Elixir 1.14
      # that accepts plug_crypto 2.x.
      {:plug, "~> 1.19.0"},
      {:jason, "~> 1.4"}
    ]
  end
end
