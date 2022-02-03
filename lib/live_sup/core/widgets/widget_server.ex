defmodule LiveSup.Core.Widgets.WidgetServer do
  alias LiveSup.Core.Widgets.WidgetData
  alias LiveSup.Telemetry
  alias LiveSup.Helpers.StringHelper
  use Timex
  import Logger

  @callback build_data(Map.t()) :: {:ok, term} | {:error, String.t()}
  @callback default_title() :: String.t()
  # @callback get_data() :: {:ok, LiveSup.Core.Widgets.WidgetData.t()} | {:error, String.t()}

  defmacro __using__(_) do
    quote do
      @behaviour LiveSup.Core.Widgets.WidgetServer
      use GenServer

      alias LiveSup.Core.Widgets.{WidgetRegistry, WorkerTaskSupervisor}
      alias LiveSup.Schemas.{Widget, WidgetInstance, User}

      def start_link(%WidgetInstance{} = widget_instance) do
        GenServer.start_link(
          __MODULE__,
          widget_instance,
          name: via_tuple(widget_instance)
        )
      end

      def start_link([%WidgetInstance{} = widget_instance, user_id]) do
        GenServer.start_link(
          __MODULE__,
          widget_instance,
          name: via_tuple(widget_instance, user_id)
        )
      end

      def init(widget_instance) do
        Telemetry.execute(
          Telemetry.Events.widget_init(),
          %{system_time: System.monotonic_time()},
          %{
            widget_instance: %{
              name: widget_instance.name
            },
            datasource_instance: %{
              name: widget_instance.datasource_instance.name
            }
          }
        )

        # We should schedule the work from the
        # widget configuration
        # schedule_work()
        widget_data = build_model(widget_instance)

        # Let's fetch the data async. We don't really care when that
        # is going to happen, since we are sending push notifications
        # the server will allways return "in-progress" until fetch is
        # complete
        self() |> send(:fetch_data)

        # Since the task to fetch the data is async
        # The UI could not be ready when we broadcast
        # the data. So let's brodcast again in a few seconds
        # just to make sure the UI has the last state
        Process.send_after(self(), :broadcast, 3000)
        debug("widget_server:init")

        {:ok, [widget_instance: widget_instance, widget_data: widget_data]}
      end

      def handle_info(:fetch_data,
            widget_instance: %{name: name} = widget_instance,
            widget_data: widget_data
          ) do
        debug("widget_server.handle_info:fetch_data: #{name}")

        # Im not really sure if this is ok to use a Task inside
        # a genserver, but I didn't want to have calls hanging because
        # the fetching data is taking too long.
        # Task.async(fn -> {:from_task, widget_instance |> fetch_data()} end)
        WorkerTaskSupervisor.fetch_data(__MODULE__, widget_instance)

        {:noreply, [widget_instance: widget_instance, widget_data: widget_data]}
      end

      # When the task is completed, this is the handler
      # that will receive the message
      def fetch_data(widget_instance) do
        debug("fetch_data: #{widget_instance.name}")

        data =
          :telemetry.span(
            Telemetry.Events.widget_build_data(),
            %{widget_instance: widget_instance},
            fn ->
              data =
                __MODULE__.build_data(
                  widget_instance
                  |> WidgetInstance.get_settings(__MODULE__.settings_keys())
                )

              {data, %{widget_instance: widget_instance}}
            end
          )

        widget_data =
          data
          |> build_model(widget_instance)

        {:from_task, widget_data}
      end

      def handle_info(
            {_task, {:from_task, widget_data}},
            widget_instance: widget_instance,
            widget_data: _widget_data
          ) do
        widget_instance
        |> calculate_next_cycle_delay()
        |> run_next()

        debug("widget_server.broadcasting: widgets:#{widget_instance.id}")

        LiveSupWeb.Endpoint.broadcast_from(self(), "widgets:#{widget_data.id}", "update", %{
          body: widget_data
        })

        {:noreply, [widget_instance: widget_instance, widget_data: widget_data]}
      end

      def handle_info(:broadcast,
            widget_instance: widget_instance,
            widget_data: widget_data
          ) do
        debug("widget_server.broadcasting: widgets:#{widget_data.id}")

        LiveSupWeb.Endpoint.broadcast_from(self(), "widgets:#{widget_data.id}", "update", %{
          body: widget_data
        })

        {:noreply, [widget_instance: widget_instance, widget_data: widget_data]}
      end

      def handle_call(
            :data,
            from,
            [widget_instance: widget_instance, widget_data: widget_data] = data
          ) do
        debug("handle_call: #{widget_instance.name}")
        {:reply, widget_data, data}
      end

      def handle_info(:data, state) do
        {:noreply, state, {:continue, :fetch_data}}
      end

      def handle_info(_, state), do: {:noreply, state}

      def get_data(%WidgetInstance{} = widget_instance, %User{} = user) do
        widget_instance.id
        |> get_data(user.id)
      end

      def get_data(%WidgetInstance{} = widget_instance) do
        widget_instance.id
        |> get_data()
      end

      def get_data(widget_instance_id) do
        GenServer.call(via_tuple(widget_instance_id), :data)
      end

      def get_data(widget_instance_id, user_id) do
        GenServer.call(via_tuple(widget_instance_id, user_id), :data)
      end

      defp build_model(%WidgetInstance{} = widget_instance) do
        WidgetData.build_in_progress(
          id: widget_instance.id,
          title: title(widget_instance),
          ui_settings: Widget.ui_settings(widget_instance.widget.ui_settings)
        )
      end

      defp build_model({:ok, data}, widget_instance) do
        custom_title = WidgetInstance.custom_title(widget_instance)

        WidgetData.build_ready(
          id: widget_instance.id,
          title: title(widget_instance),
          data: data,
          ui_settings: Widget.ui_settings(widget_instance.widget.ui_settings)
        )
      end

      defp build_model({:error, error}, widget_instance) do
        WidgetData.build_error(
          id: widget_instance.id,
          title: title(widget_instance),
          error: error,
          ui_settings: Widget.ui_settings(widget_instance.widget.ui_settings)
        )
      end

      defp title(widget_instance) do
        title = WidgetInstance.custom_title(widget_instance) || __MODULE__.default_title()
        settings = StringHelper.find_placeholders(title)

        title
        |> parse_title(widget_instance, settings)
      end

      defp parse_title(default_title, widget_instance, nil), do: default_title

      defp parse_title(default_title, widget_instance, settings) do
        settings
        |> Enum.reduce(default_title, fn key, new_title ->
          WidgetInstance.get_setting(widget_instance, key)
          |> replace_title_key(new_title, key)
        end)
      end

      defp replace_title_key(nil, title, key), do: title

      defp replace_title_key(value, title, key) when is_binary(value),
        do: String.replace(title, "{#{key}}", value)

      defp replace_title_key(value, title, key),
        do: String.replace(title, "{#{key}}", Integer.to_string(value))

      defp via_tuple(%WidgetInstance{} = widget_instance) do
        via_tuple(widget_instance.id)
      end

      defp via_tuple(%WidgetInstance{} = widget_instance, %User{} = user) do
        via_tuple(widget_instance.id, user.id)
      end

      defp via_tuple(%WidgetInstance{} = widget_instance, user_id) do
        via_tuple(widget_instance.id, user_id)
      end

      defp via_tuple(widget_instance_id) do
        {:via, Registry, {WidgetRegistry.name(), widget_instance_id}}
      end

      defp via_tuple(widget_instance_id, user_id) do
        {:via, Registry, {WidgetRegistry.name(), "#{widget_instance_id}:#{user_id}"}}
      end

      defp calculate_next_cycle_delay(widget_instance) do
        run_every =
          widget_instance
          |> WidgetInstance.get_setting("runs_every")

        (run_every || 0) * 1000
      end

      def run_next(0), do: nil
      def run_next(value), do: Process.send_after(self(), :fetch_data, value)
    end
  end
end
