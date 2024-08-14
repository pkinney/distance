defmodule Distance.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :distance,
      version: "1.1.1",
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      dialyzer: [plt_add_apps: [:mix, :seg_seg]],
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application() do
    [extra_applications: [:logger]]
  end

  defp deps() do
    [
      {:seg_seg, "~> 0.1 or ~> 1.0"},
      {:earmark, "~> 1.1", only: :dev},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:benchfella, "~> 0.3.4", only: :dev},
      {:excoveralls, "~> 0.6", only: :test},
      {:stream_data, "~> 0.5", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    Various distance functions for geometric or geographic calculations
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Powell Kinney"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/pkinney/distance"}
    ]
  end

  defp aliases() do
    [
      validate: [
        "clean",
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo",
        "dialyzer"
      ]
    ]
  end
end
