defmodule LoanRanger.MixProject do
  use Mix.Project

  def project do
    [
      app: :loan_ranger,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.14", only: [:dev, :docs]},
      {:money, "~> 1.4"},
      {:decimal, "~> 1.0"},
      {:timex, "~> 3.5"}
    ]
  end
end
