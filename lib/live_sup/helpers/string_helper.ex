defmodule LiveSup.Helpers.StringHelper do
  def truncate(text, opts \\ []) do
    max_length = opts[:max_length] || 50
    omission = opts[:omission] || "..."

    cond do
      not String.valid?(text) ->
        text

      String.length(text) < max_length ->
        text

      true ->
        length_with_omission = max_length - String.length(omission)

        "#{String.slice(text, 0, length_with_omission)}#{omission}"
    end
  end

  def find_placeholders(str) do
    Regex.scan(~r{\{(.*?)\}}, str) |> Enum.map(&tl/1) |> List.flatten()
  end
end
