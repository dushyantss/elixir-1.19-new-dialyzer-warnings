defmodule ElixirDialyzerWarnings.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_dialyzer_warnings,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Elixir 1.19 New Dialyzer Warnings",
      description: "Reproduction cases for new dialyzer warnings in Elixir 1.19 / Erlang 28.1",
      source_url: "https://github.com/YOUR_USERNAME/elixir-1.19-new-dialyzer-warnings"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.13"},
      {:ecto_sql, "~> 3.13"},
      {:postgrex, "~> 0.19"},
      {:carbonite, "~> 0.4"},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false}
    ]
  end
end
