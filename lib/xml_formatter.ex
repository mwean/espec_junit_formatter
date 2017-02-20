defmodule ESpec.JUnitFormatter.XMLFormatter do
  require Record

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

  def format(stats, examples) do
    root = {:testsuites, [], [generate_testsuite_xml(stats, examples)]}
    :xmerl.export_simple([root], :xmerl_xml)
  end

  defp generate_testsuite_xml(stats, examples) do
    {
      :testsuite,
      Map.to_list(stats),
      Enum.map(examples, &(generate_testcase(&1)))
    }
  end

  defp generate_testcase(example) do
    {
      :testcase,
      Map.to_list(example.attributes),
      generate_test_body(example)
    }
  end

  defp generate_test_body(%{status: :success}), do: []
  defp generate_test_body(example) do
    [{example.status, [message: example.message], test_content(example.content)}]
  end

  defp test_content(nil), do: []
  defp test_content(content), do: [String.to_char_list(content)]
end
