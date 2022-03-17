defmodule LiveSup.Core.Widgets.RssServiceStatus.List.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.RssServiceStatus.Single.Handler

  @default_title "Rss Services Status"

  def settings_keys, do: ["services"]

  @impl true
  def build_data(%{"services" => services}) do
    services
    |> Enum.map(&process_service/1)
    |> Enum.sort(&(DateTime.compare(&1.created_at, &2.created_at) != :lt))
    |> (fn new_struct -> {:ok, new_struct} end).()
  end

  defp process_service(%{"url" => url} = service) do
    url
    |> Handler.get_data()
    |> process_data(service)
  end

  defp process_data({:ok, data}, %{"icon" => icon, "name" => name}) do
    data
    |> Map.put(:icon, icon)
    |> Map.put(:service_name, name)
  end

  defp process_data({:error, error}, %{"icon" => icon, "name" => name, "url" => url}) do
    %{
      service_name: name,
      icon: icon,
      title: "Error reading the service status",
      url: url,
      status: :error,
      created_at: nil,
      created_at_ago: nil
    }
  end

  @impl true
  def default_title() do
    @default_title
  end
end
