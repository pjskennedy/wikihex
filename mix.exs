defmodule Wikihex.MixProject do
  use Mix.Project

  def project do
    [
      app: :wikihex,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.4"},
      {:exvcr, "~> 0.10", only: :test}
    ]
  end
end
