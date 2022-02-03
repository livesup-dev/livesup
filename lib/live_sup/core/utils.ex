defmodule LiveSup.Core.Utils do
  def convert_to_module(module_name) do
    "Elixir.#{module_name}"
    |> String.to_existing_atom()
  end
end
