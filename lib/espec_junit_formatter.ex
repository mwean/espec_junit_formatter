defmodule ESpec.JUnitFormatter do
  use ESpec.Formatters.Base

  def init(opts) do
    {:ok, opts}
  end

  def handle_cast({:final_result, examples, durations}, opts) do
    stats = calculate_stats(examples, durations)
    examples = convert_to_junit(examples)
    report = ESpec.JUnitFormatter.XMLFormatter.format(stats, examples)

    if opts[:out_path] do
      write_to_file(opts[:out_path], report)
    else
      IO.write(report)
    end

    {:noreply, opts}
  end

  def handle_cast({:example_finished, example}, opts) do
    IO.inspect example
    {:noreply, opts}
  end

  def handle_cast(_, opts), do: {:noreply, opts}

  defp convert_to_junit([]), do: []
  defp convert_to_junit([example | others]) do
    [convert_to_junit(example) | convert_to_junit(others)]
  end

  defp convert_to_junit(example) do
    %{
      status: example_status(example),
      message: example_message(example),
      content: example_content(example),
      attributes: build_attributes(example)
    }
  end

  defp build_attributes(example) do
    module_name = to_string(example.module) |> String.replace_prefix("Elixir.", "")

    %{
      classname: module_name,
      name: one_line_description(example) |> String.replace_prefix("#{module_name} ", ""),
      file: example.file,
      line: example.line,
      time: example.duration |> us_to_sec
    }
  end

  defp example_status(%ESpec.Example{status: :success}), do: :success
  defp example_status(%ESpec.Example{status: :failure}), do: :failure
  defp example_status(%ESpec.Example{status: :pending}), do: :skipped

  defp example_message(%ESpec.Example{status: :failure, error: %ESpec.AssertionError{message: message}}), do: message
  defp example_message(%ESpec.Example{status: :pending, result: result}), do: result
  defp example_message(_), do: nil

  defp example_content(%ESpec.Example{status: :failure, error: %ESpec.AssertionError{message: message}}), do: message
  defp example_content(_), do: nil

  defp one_line_description(example) do
    ESpec.Example.context_descriptions(example) ++ [example.description]
    |> Enum.join(" ")
    |> String.rstrip
  end

  defp calculate_stats(examples, {start_loading_time, _, finish_specs_time}) do
    initial_stats = %{
      name: "ESpec",
      time: :timer.now_diff(finish_specs_time, start_loading_time) |> us_to_sec,
      errors: 0,
      failures: 0,
      skipped: 0,
      tests: 0
    }

    Enum.reduce examples, initial_stats, fn(example, stats) ->
      Map.update!(stats, :tests, &(&1 + 1))
      |> update_stats(example)
    end
  end

  defp write_to_file(path, report) do
    File.mkdir_p!(Path.dirname(path))
    File.open!(path, [:write], fn(file) -> IO.binwrite(file, report) end)
  end

  defp update_stats(stats, %ESpec.Example{status: :pending}) do
    Map.update!(stats, :skipped, &(&1 + 1))
  end

  defp update_stats(stats, %ESpec.Example{status: :failure}) do
    Map.update!(stats, :failures, &(&1 + 1))
  end
  defp update_stats(stats, _), do: stats

  defp us_to_sec(useconds) do
    seconds = useconds / 1_000_000
    seconds_str = to_string(seconds)

    if String.contains?(seconds_str, "e-") do
      [_, exponent] = String.split(seconds_str, "e-")
      :erlang.float_to_binary(seconds, [{:decimals, String.to_integer(exponent)}])
    else
      seconds_str
    end
  end
end
