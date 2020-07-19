defmodule Snoop.MixProject do
  use Mix.Project

  def project do
    [
      app: :snoop,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Snoop",
      source_url: "https://github.com/supersimple/snoop"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp description() do
    """
    Snoop smokes trees.
    Specifically, it take a path and build an HTML list describing the
    directories and files in that path.
    """
  end

  defp package() do
    files: ~w(lib .formatter.exs mix.exs README* readme* LICENSE* license* CHANGELOG* changelog*),
    licenses: ["MIT"]
    links: %{"GitHub" => "https://github.com/supersimple/snoop"}
  end
end
