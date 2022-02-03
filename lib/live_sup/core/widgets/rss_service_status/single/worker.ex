defmodule LiveSup.Core.Widgets.RssServiceStatus.Single.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.RssServiceStatus.Single.Handler

  @default_title "Rss Service Status"

  def settings_keys, do: ["url", "icon"]

  @impl true
  def build_data(%{"url" => url, "icon" => icon}) do
    url
    |> Handler.get_data()
    |> add_service_icon(icon)
  end

  defp add_service_icon({:ok, data}, icon) do
    data
    |> Map.put(:icon, icon)
    |> (fn new_struct -> {:ok, new_struct} end).()
  end

  defp add_service_icon({:error, error}, _widget_instance), do: {:error, error}

  @impl true
  def default_title() do
    @default_title
  end
end
