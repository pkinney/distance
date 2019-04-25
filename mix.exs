defmodule Distance.Mixfile do
  use Mix.Project

  def project do
    [app: :distance,
     version: "0.2.2",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:seg_seg, "~> 0.1"},
      {:earmark, "~> 1.1", only: :dev},
      {:ex_doc, "~> 0.15", only: :dev},
      {:benchfella, "~> 0.3.4", only: :dev},
      {:excoveralls, "~> 0.6", only: :test}
    ]
  end

  defp description do
    """
    Various distance functions for geometric or geographic calculations
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Powell Kinney"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/pkinney/distance"}
    ]
  end
end
