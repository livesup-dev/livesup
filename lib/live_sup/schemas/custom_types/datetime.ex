defmodule LiveSup.Schemas.CustomTypes.Datetime do
  use Ecto.Type

  def type, do: :utc_datetime

  def cast(string_date) when is_binary(string_date) do
    case Timex.parse(string_date, "{YYYY}-{0M}-{0D}") do
      {:error, error} ->
        {:error, error}

      {:ok, value} ->
        Ecto.Type.cast(type(), value)
    end
  end

  def cast(data), do: Ecto.Type.cast(type(), data)

  def load(value), do: {:ok, value}
  def dump(:utc_datetime = value), do: {:ok, value}
  def dump(value), do: Ecto.Type.dump(type(), value)
end
