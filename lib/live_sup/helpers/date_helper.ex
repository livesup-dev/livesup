defmodule LiveSup.Helpers.DateHelper do
  use Timex

  def current_minutes() do
    {:ok, formated_date} =
      DateTime.utc_now()
      |> Timex.format("{h24}:{m} {Zabbr}")

    formated_date
  end

  def from_now(date), do: Timex.from_now(date)

  def from_now(), do: Timex.from_now(DateTime.utc_now())

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
end
