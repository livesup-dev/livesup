defmodule LiveSup.PromEx.WidgetPlugin do
  use PromEx.Plugin
  alias LiveSup.Telemetry

  @impl true
  def event_metrics(_opts) do
    bucket_intervals = [10, 100, 250, 500, 1_000, 2_000, 5_000, 10_000]

    [
      Event.build(
        :live_sup_widgets,
        [
          distribution(
            [:live_sup, :build_data, :duration, :milliseconds],
            event_name: Telemetry.Events.widget_build_data_stop(),
            measurement: :duration,
            description: "The time it takes for the widget to build the data.",
            reporter_options: [
              buckets: bucket_intervals
            ],
            tag_values: &get_build_data_tags/1,
            tags: [:name, :datasource_name],
            unit: {:native, :millisecond}
          ),
          counter(
            [:live_sup, :widget, :active, :count],
            event_name: Telemetry.Events.widget_init(),
            description: "Number of active widgets."
          ),
          last_value(
            [:live_sup, :init, :info],
            event_name: Telemetry.Events.widget_init(),
            description: "Information regarding LiveSup",
            measurement: fn _measurements -> 1 end,
            tags: [:environment],
            tag_values: &init_tag_values/1
          )
          |> PromEx.Debug.attach_debugger()
        ]
      )
    ]
  end

  defp get_build_data_tags(%{
         widget_instance: %{name: name, datasource_instance: %{name: datasource_instance_name}}
       }) do
    %{
      name: name,
      datasource_name: datasource_instance_name
    }
  end

  def init_tag_values(_args) do
    %{
      environment: Mix.env()
    }
  end
end
