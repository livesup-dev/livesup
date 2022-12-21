defmodule LiveSupWeb.Live.Widgets.WidgetLive do
  @callback render_widget(map) :: Phoenix.LiveView.Rendered.t()

  defmacro __using__(_) do
    quote do
      @behaviour LiveSupWeb.Live.Widgets.WidgetLive
      use Phoenix.LiveView,
        layout: {LiveSupWeb.LayoutView, :live}

      import Logger

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers
      # import LiveSupWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import LiveSupWeb.ErrorHelpers
      import LiveSupWeb.Gettext
      alias LiveSupWeb.Router.Helpers, as: Routes

      alias LiveSupWeb.Live.Components.{
        SmartRenderComponent,
        WidgetHeaderComponent,
        WidgetFooterComponent
      }

      # Custom helpers
      import LiveSupWeb.Helpers

      alias LiveSup.Core.Utils
      import LiveSupWeb.Live.AuthHelper
      alias LiveSup.Schemas.{WidgetInstance, User}
      alias LiveSup.Core.Widgets.WidgetData

      @impl true
      def mount(_params, session, socket) do
        current_user = get_current_user(session, socket)
        debug("mount: #{__MODULE__}")
        # TODO: We need to get rid of having the widget_instance in the session.
        %{id: widget_instance_id, widget: %{global: global}} = session["widget_instance"]

        # TODO: We have to connect to the user specific channel
        if connected?(socket),
          do: global |> connect_to_channel(widget_instance_id, current_user.id)

        {:ok,
         assign(socket,
           current_user: current_user,
           widget_instance: session["widget_instance"]
         )}
      end

      defp connect_to_channel(true = global, widget_instance_id, _user_id),
        do: LiveSupWeb.Endpoint.subscribe("widgets:#{widget_instance_id}")

      defp connect_to_channel(false = global, widget_instance_id, user_id),
        do: LiveSupWeb.Endpoint.subscribe("widgets:#{widget_instance_id}:#{user_id}")

      @impl true
      def render(assigns) do
        widget_instance = assigns[:widget_instance]
        current_user = assigns[:current_user]

        widget_data =
          get_data(
            widget_instance,
            current_user
          )

        assigns =
          assigns
          |> assign(:widget_data, widget_data)

        __MODULE__.render_widget(assigns)
      end

      # defp schedule_refresh(%{state: :in_progress} = widget_data, widget_instance, current_user) do
      #   Process.send_after(
      #     self(),
      #     {:refresh_component,
      #      %{
      #        widget_instance: widget_instance,
      #        current_user: current_user
      #      }},
      #     2000
      #   )

      #   widget_data
      # end

      # defp schedule_refresh(%{state: :error}= widget_data, _widget_instance, _current_user), do: widget_data
      # defp schedule_refresh(%{state: :ready}= widget_data, _widget_instance, _current_user), do: widget_data

      # def handle_info(:refresh_component, %{
      #       widget_instance: widget_instance,
      #       current_user: current_user
      #     }) do
      #   widget_data =
      #     get_data(
      #       widget_instance,
      #       current_user
      #     )

      #   send_update(SmartRenderComponent,
      #     id: widget_data.id,
      #     widget_data: widget_data
      #   )

      #   {:noreply}
      # end

      @impl true
      def handle_info(%{event: "update", payload: %{body: widget_data}}, socket) do
        debug("widget_live.handle_info: #{widget_data.title}")

        send_update(SmartRenderComponent,
          id: widget_data.id,
          widget_data: widget_data
        )

        {:noreply, socket}
      end

      def get_data(
            %{widget: %{global: true, worker_handler: worker_handler}} = widget_instance,
            _current_user
          ) do
        Utils.convert_to_module(worker_handler).get_data(widget_instance)
      end

      def get_data(
            %{widget: %{global: false, worker_handler: worker_handler}} = widget_instance,
            current_user
          ) do
        Utils.convert_to_module(worker_handler).get_data(widget_instance, current_user)
      end
    end
  end
end
