defmodule Absinthe.Upload.MixProject do
  use Mix.Project

  def project do
    [
      app: :absinthe_upload,
      version: "0.1.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/shavit/absinthe-upload",
      description: "Absinthe plug to support Apollo upload format",
      package: [
        links: %{
          "Github" => "https://github.com/shavit/absinthe-upload"
        },
        licenses: ["Apache 2.0"]
      ]
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
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:jason, "~> 1.2"}
    ]
  end
end
