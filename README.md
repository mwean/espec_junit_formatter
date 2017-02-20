# ESpec.JUnitFormatter

ESpec formatter for the JUnit XML format

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `espec_junit_formatter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:espec_junit_formatter, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/espec_junit_formatter](https://hexdocs.pm/espec_junit_formatter).

## Usage

To use this formatter, add this to your `spec_helper.exs` file:

```elixir
ESpec.configure fn(config) ->
  config.formatters [
    {ESpec.JUnitFormatter, %{out_path: "some/path/junit.xml"}}
  ]
end

```

## Acknowledgements

This draws heavily from [victorolinasc/junit-formatter](https://github.com/victorolinasc/junit-formatter)
