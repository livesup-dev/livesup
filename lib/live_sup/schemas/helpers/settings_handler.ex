defmodule LiveSup.Schemas.Helpers.SettingsHandler do
  def find_values(keys) do
    keys
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.merge(acc, %{key => find_value(value)})
    end)
  end

  def find_value(%{"type" => "string", "value" => value, "source" => "local"})
      when is_integer(value) do
    value |> Integer.to_string()
  end

  def find_value(%{"type" => "string", "value" => value, "source" => "local"}), do: value

  def find_value(%{"type" => "int", "value" => value, "source" => "local"})
      when is_binary(value) do
    case Integer.parse(value) do
      {int_val, ""} -> int_val
      :error -> raise "#{value} is not a valid int"
    end
  end

  def find_value(%{"type" => "array", "value" => value, "source" => "local"})
      when is_binary(value) do
    value
    |> String.split(",")
  end

  def find_value(%{"type" => "int", "value" => value}), do: value
  def find_value(%{"source" => "env", "value" => env_var}), do: System.get_env(env_var)
  def find_value(%{"source" => "local", "value" => value}), do: value
  def find_value(value), do: value

  def get_values_from_settings(settings, keys) do
    settings
    |> Map.take(keys)
  end
end
