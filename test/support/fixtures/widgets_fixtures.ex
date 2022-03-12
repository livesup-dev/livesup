defmodule LiveSup.Test.WidgetsFixtures do
  alias LiveSup.Test.DatasourcesFixtures

  def widget_fixture(%LiveSup.Schemas.Datasource{} = datasource, attrs \\ %{}) do
    unique_key = System.unique_integer()

    {:ok, widget} =
      attrs
      |> Enum.into(%{
        name: "Last Rollbar Errors",
        slug: "last-rollbar-errors#{unique_key}",
        enabled: true,
        worker_handler: "LiveSup.Core.Widgets.LordOfTheRingQuote.Worker",
        ui_handler: "LiveSupWeb.Live.Widgets.LordOfTheRingQuoteLive",
        labels: [],
        global: true,
        settings: %{"number_of_errors" => 5},
        datasource_id: datasource.id
      })
      |> LiveSup.Core.Widgets.create()

    widget
  end

  def widget_with_datasource_fixture(attrs \\ %{}) do
    datasource = DatasourcesFixtures.datasource_fixture()
    unique_key = System.unique_integer()

    {:ok, widget} =
      attrs
      |> Enum.into(%{
        name: "Last Rollbar Errors",
        slug: "last-rollbar-errors#{unique_key}",
        enabled: true,
        worker_handler: "LiveSup.Core.Widgets.LordOfTheRingQuote.Worker",
        ui_handler: "LiveSupWeb.Live.Widgets.LordOfTheRingQuoteLive",
        labels: [],
        global: true,
        settings: %{"number_of_errors" => 5},
        datasource_id: datasource.id
      })
      |> LiveSup.Core.Widgets.create()

    widget
  end
end
