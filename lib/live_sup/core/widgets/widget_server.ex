defmodule LiveSup.Core.Widgets.WidgetServer do
  alias LiveSup.Core.Widgets.WidgetData
  alias LiveSup.Telemetry
  alias LiveSup.Helpers.StringHelper
  alias LiveSup.Schemas.User
  alias LiveSup.Core.Widgets.WidgetContext
  alias LiveSup.Core.Users

  use Timex

  @callback build_data(Map.t(), WidgetContext.t()) :: {:ok, term} | {:error, String.t()}
  @callback default_title() :: String.t()

  @callback public_settings() :: List.t()
  @callback settings_keys() :: List.t()

  @optional_callbacks public_settings: 0

  defmacro __using__(_) do
    quote do
      @behaviour LiveSup.Core.Widgets.WidgetServer
      use GenServer
      use LiveSup.Core.Widgets.WidgetLogger

      alias LiveSup.Core.Widgets.{WidgetRegistry, WorkerTaskSupervisor}
      alias LiveSup.Schemas.{Widget, WidgetInstance, User}

      def start_link(%WidgetContext{} = widget_context) do
        debug("#{__MODULE__}: start_link")

        GenServer.start_link(
          __MODULE__,
          widget_context,
          name: via_tuple(widget_context)
        )
      end

      def init(%{widget_instance: widget_instance} = widget_context) do
        debug("init")
        # TODO: Refactor these lines. Move all into a module
        Telemetry.execute(
          Telemetry.Events.widget_init_for_user(),
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
        widget_data = widget_instance |> build_model()

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

        {:ok, WidgetContext.update_data(widget_context, widget_data)}
      end

      # def handle_info(:fetch_data,
      #       widget_instance: %{name: name} = widget_instance,
      #       widget_data: widget_data,
      #       user: user
      #     ) do
      #   debug("widget_server.handle_info:fetch_data: #{name}")

      #   # Im not really sure if this is ok to use a Task inside
      #   # a genserver, but I didn't want to have calls hanging because
      #   # the fetching data is taking too long.
      #   # Task.async(fn -> {:from_task, widget_instance |> fetch_data()} end)
      #   WorkerTaskSupervisor.fetch_data(__MODULE__, widget_instance, user)

      #   {:noreply, [widget_instance: widget_instance, widget_data: widget_data, user: user]}
      # end

      def handle_info(
            :fetch_data,
            %{widget_instance: %{id: id}} = widget_context
          ) do
        debug("handle_info:fetch_data: #{id}")

        # Im not really sure if this is ok to use a Task inside
        # a genserver, but I didn't want to have calls hanging because
        # the fetching data is taking too long.
        # Task.async(fn -> {:from_task, widget_instance |> fetch_data()} end)
        WorkerTaskSupervisor.fetch_data(__MODULE__, widget_context)

        {:noreply, widget_context}
      end

      # When the task is completed, this is the handler
      # that will receive the message
      def fetch_data(%{widget_instance: widget_instance} = widget_context) do
        debug("fetch_data: #{widget_instance.id}")

        data =
          :telemetry.span(
            Telemetry.Events.widget_build_data(),
            %{widget_instance: widget_instance},
            fn ->
              data =
                widget_context
                |> worker_build_data()

              {data, %{widget_instance: widget_instance}}
            end
          )

        widget_data =
          data
          |> build_model(widget_instance)

        debug("fetch_data.widget_data.state: #{widget_data.state}")

        {:from_task, widget_data}
      end

      # When the task is completed, this is the handler
      # that will receive the message
      # def fetch_data(%{widget_instance: widget_instance, user: user}) do
      #   debug("fetch_data: #{widget_instance.name}")

      #   data =
      #     :telemetry.span(
      #       Telemetry.Events.widget_build_data(),
      #       %{widget_instance: widget_instance},
      #       fn ->
      #         data =
      #           widget_instance
      #           |> worker_build_data(user)

      #         {data, %{widget_instance: widget_instance}}
      #       end
      #     )

      #   widget_data =
      #     data
      #     |> build_model(widget_instance)

      #   {:from_task, widget_data}
      # end

      def worker_build_data(%{widget_instance: widget_instance} = widget_context) do
        __MODULE__.build_data(
          widget_instance
          |> WidgetInstance.get_settings(__MODULE__.settings_keys()),
          widget_context
        )
      end

      def handle_info(
            {_task, {:from_task, widget_data}},
            %{widget_instance: widget_instance} = widget_context
          ) do
        widget_instance
        |> calculate_next_cycle_delay()
        |> run_next()

        debug("handle_info.from_task:#{widget_instance.id}")
        debug("handle_info.from_task:#{widget_data.state}")

        # TODO: Broadcast to the user if the widget is for users
        widget_context |> broadcast_data()

        {:noreply, WidgetContext.update_data(widget_context, widget_data)}
      end

      def handle_info(
            :broadcast,
            %{widget_data: widget_data} = widget_context
          ) do
        debug("widget_server.broadcasting: widgets:#{widget_data.id}")

        widget_context |> broadcast_data()

        {:noreply, widget_context}
      end

      defp broadcast_data(%{widget_data: widget_data, widget_instance: %{widget: %{global: true}}}) do
        LiveSupWeb.Endpoint.broadcast_from(self(), "widgets:#{widget_data.id}", "update", %{
          body: widget_data
        })
      end

      defp broadcast_data(%{
             widget_data: widget_data,
             widget_instance: %{widget: %{global: false}},
             user: %{id: user_id}
           }) do
        LiveSupWeb.Endpoint.broadcast_from(
          self(),
          "widgets:#{widget_data.id}:#{user_id}",
          "update",
          %{
            body: widget_data
          }
        )
      end

      def handle_call(
            :data,
            from,
            %{widget_data: widget_data, widget_instance: widget_instance} = widget_context
          ) do
        debug("handle_call: #{widget_instance.id}")
        debug("handle_call.state: #{widget_data.state}")
        {:reply, widget_data, widget_context}
      end

      # def handle_info(:data, state) do
      #   {:noreply, state, {:continue, :fetch_data}}
      # end

      def handle_info(_, state), do: {:noreply, state}

      def get_data(%WidgetInstance{id: widget_instance_id}, %User{id: user_id}) do
        widget_instance_id
        |> get_data(user_id)
      end

      def get_data(%WidgetInstance{id: widget_instance_id}, user_id) when is_binary(user_id) do
        widget_instance_id
        |> get_data(user_id)
      end

      def get_data(%WidgetInstance{id: widget_instance_id}) do
        widget_instance_id
        |> get_data()
      end

      def get_data(widget_instance_id) do
        debug("get_data.from_instance: #{widget_instance_id}")
        GenServer.call(via_tuple(widget_instance_id), :data)
      end

      def get_data(widget_instance_id, user_id) do
        debug("get_data.from_user: #{widget_instance_id}/#{user_id}")
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
        WidgetData.build_ready(
          id: widget_instance.id,
          title: title(widget_instance),
          data: data,
          ui_settings: Widget.ui_settings(widget_instance.widget.ui_settings),
          public_settings:
            find_public_settings(
              function_exported?(__MODULE__, :public_settings, 0),
              widget_instance
            )
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

      defp find_public_settings(true, widget_instance) do
        widget_instance
        |> WidgetInstance.get_settings(__MODULE__.public_settings())
      end

      defp find_public_settings(false, _widget_instance), do: %{}

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

      # defp via_tuple(%WidgetContext{} = widget_context) do
      #   widget_context |> via_tuple()
      # end

      defp via_tuple(%{
             widget_instance: %{id: widget_instance_id, widget: %{global: false}},
             user: %{id: user_id}
           }) do
        debug("via_tuple.global:false")
        {:via, Registry, {WidgetRegistry.name(), "#{widget_instance_id}:#{user_id}"}}
      end

      defp via_tuple(%{
             widget_instance: %{id: widget_instance_id, widget: %{global: true}}
           }) do
        debug("via_tuple.global:true")
        {:via, Registry, {WidgetRegistry.name(), "#{widget_instance_id}"}}
      end

      defp via_tuple(widget_instance_id, user_id) do
        debug("via_tuple.global:false")
        {:via, Registry, {WidgetRegistry.name(), "#{widget_instance_id}:#{user_id}"}}
      end

      defp via_tuple(widget_instance_id) do
        debug("via_tuple.global:true")
        {:via, Registry, {WidgetRegistry.name(), "#{widget_instance_id}"}}
      end

      # Converting seconds to miliseconds
      defp calculate_next_cycle_delay(widget_instance) do
        run_every =
          widget_instance
          |> WidgetInstance.get_setting("runs_every")

        (run_every || 0) * 1000
      end

      def run_next(0), do: nil
      def run_next(value), do: Process.send_after(self(), :fetch_data, value)

      defp find_user(user_id) when is_binary(user_id), do: Users.get!(user_id)
      defp find_user(nil), do: nil
    end
  end
end
