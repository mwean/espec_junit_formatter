# ESpec.JUnitFormatter

ESpec formatter for the JUnit XML format

## Installation

Add `espec_junit_formatter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:espec_junit_formatter, "~> 0.1.1"}]
end
```

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
