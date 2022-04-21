defmodule LiveSup.Helpers.DateHelper do
  use Timex

  def current_minutes() do
    {:ok, formated_date} =
      DateTime.utc_now()
      |> Timex.format("{h24}:{m} {Zabbr}")

    formated_date
  end

  def from_now(date), do: Timex.from_now(date)

  def from_now(date, :short) do
    str_date = Timex.from_now(date)

    # TODO: This is ugly as hell
    cond do
      String.contains?(str_date, "second ago") -> String.replace(str_date, " second ago", "s")
      String.contains?(str_date, "seconds ago") -> String.replace(str_date, " seconds ago", "s")
      String.contains?(str_date, "minute ago") -> String.replace(str_date, " minute ago", "m")
      String.contains?(str_date, "minutes ago") -> String.replace(str_date, " minutes ago", "m")
      String.contains?(str_date, "hour ago") -> String.replace(str_date, " hour ago", "h")
      String.contains?(str_date, "hours ago") -> String.replace(str_date, " hours ago", "h")
      String.contains?(str_date, "day ago") -> String.replace(str_date, " day ago", "d")
      String.contains?(str_date, "days ago") -> String.replace(str_date, " days ago", "d")
      String.contains?(str_date, "month ago") -> String.replace(str_date, " month ago", "mo")
      String.contains?(str_date, "months ago") -> String.replace(str_date, " months ago", "mo")
      true -> str_date
    end
  end

  def from_now(), do: Timex.from_now(DateTime.utc_now())

  @spec from_unix(
          non_neg_integer,
          :microsecond
          | :microseconds
          | :millisecond
          | :milliseconds
          | :nanosecond
          | :nanoseconds
          | :native
          | :second
          | :seconds
          | pos_integer
        ) :: DateTime.t()
  def from_unix(value, unit) do
    Timex.from_unix(value, unit)
  end

  def today_to_unix() do
    DateTime.utc_now() |> DateTime.to_unix()
  end

  def to_unix(date) do
    date |> DateTime.to_unix()
  end

  def parse_date(date) do
    {:ok, parsed_date} = Timex.parse(date, "{ISO:Extended:Z}")
    parsed_date
  end

  def diff_in_days(start_date, end_date \\ NaiveDateTime.local_now()) do
    Timex.diff(end_date, start_date, :days)
  end

  def today() do
    Timex.today()
  end

  def today_as_string() do
    Timex.today()
    |> Timex.format!("%FT%T%:z", :strftime)
  end

  def date_without_year(date) do
    {:ok, value} =
      date
      |> parse_date()
      |> Timex.format("{M}/{D}")

    value
  end
end
