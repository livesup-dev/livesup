defmodule LiveSup.Core.Widgets.RssServiceStatus.Single.Handler do
  alias LiveSup.Core.Datasources.RssDatasource
  alias LiveSup.Helpers.DateHelper

  def get_data(url) do
    case RssDatasource.fetch(url) do
      {:ok, feed} -> process(feed)
      {:error, error} -> process_error(error)
    end
  end

  def process(feed) do
    last_activity =
      feed.entries
      |> Enum.filter(fn entry -> DateHelper.diff_in_days(entry[:updated]) >= 0 end)
      |> Enum.at(0)
      |> build_last_activity()

    {:ok, last_activity}
  end

  def build_last_activity(entry) do
    %{
      title: entry.title,
      url: entry.url,
      status: entry.updated |> status(),
      created_at: entry.updated,
      created_at_ago: DateHelper.from_now(entry.updated)
    }
  end

  # TODO: We should probably have a better error handler
  defp process_error(error), do: {:error, error}

  def status(date) do
    today = Date.utc_today()
    date_result = Date.compare(today, date)

    case date_result do
      :eq -> :incident
      _ -> :operational
    end
  end
end
