defmodule ESpec.JUnitFormatter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :espec_junit_formatter,
      version: "0.1.1",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:espec, "~> 1.3"},
      {:ex_doc, "~> 0.14.3", only: [:docs, :dev]}
    ]
  end

  defp description do
    """
    An ESpec formatter for the JUnit XML format.
    """
  end

  defp package do
    [
      maintainers: ["Matt Wean"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/mwean/espec_junit_formatter"
      }
    ]
  end
end
