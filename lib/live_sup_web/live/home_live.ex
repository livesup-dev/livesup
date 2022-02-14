defmodule LiveSupWeb.HomeLive do
  use LiveSupWeb, :live_view

  import LiveSupWeb.Live.AuthHelper
  import Logger
  alias LiveSup.Core.{Dashboards, Widgets.WidgetManager}
  alias LiveSup.Core.Utils

  @impl true
  def mount(_params, session, socket) do
    debug("HomeLive: mount")
    current_user = get_current_user(session, socket)

    {:ok,
     assign(socket,
       current_user: current_user,
       current_dashboard: session["current_dashboard"]
     )}
  end

  @impl true
  def render(assigns) do
    debug("HomeLive: render")

    %{id: dashboard_id} = assigns[:current_dashboard]

    widget_instances =
      get_and_start_widgets(
        dashboard_id,
        assigns[:current_user]
      )

    assigns =
      assigns
      |> assign(:widget_instances, widget_instances)

    ~H"""
    <div class="mt-2">
      <div class="grid grid-cols-1 gap-2 p-4 lg:grid-cols-2 xl:grid-cols-4">
      <%= for(widget_instance <- @widget_instances) do %>
        <%= live_render(
              @socket,
              Utils.convert_to_module(widget_instance.widget.ui_handler),
              id: widget_instance.id,
              session: %{
                "widget_instance" => widget_instance,
                "current_user" => @current_user
              }, container: {:div, class: "col-span-#{size(widget_instance)}"}) %>
      <% end %>
      </div>
    </div>
    """
  end

  def size(widget_instance) do
    widget_instance.widget.ui_settings["size"] || 1
  end

  def default_dashboard(projects) do
    projects |> Enum.at(0) |> Map.get(:dashboards) |> Enum.at(0)
  end

  def get_and_start_widgets(dashboard_id, current_user) do
    widget_instances =
      dashboard_id
      |> Dashboards.widgets_instances()

    # TODO: We can't use spawn here, since the UI will try to
    # have access to the workers without them being initialized
    # but we need to be careful with performance and the time it
    # takes to render the view
    widget_instances
    |> WidgetManager.start_widgets(current_user)

    widget_instances
  end
end
