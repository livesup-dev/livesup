defmodule LiveSup.Core.Widgets.Wordpress.WordpressConfig do
  @enforce_keys [:url, :application_password, :user]
  defstruct [:url, :application_password, :user]

  def keys() do
    Map.keys(__MODULE__.__struct__())
    |> Enum.map(&Atom.to_string/1)
    |> Enum.reject(fn value -> value == "__struct__" end)
  end

  def build(string_key_map) do
    parsed_data = for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}

    struct(__MODULE__, parsed_data)
  end
end
