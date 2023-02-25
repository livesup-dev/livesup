defmodule LiveSupWeb.Dashboard.WidgetLive do
  use LiveSupWeb, :live_view
  alias LiveSup.Core.{Dashboards, Widgets}
  alias LiveSup.Schemas.{Widget, WidgetInstance}

  on_mount(LiveSupWeb.UserLiveAuth)

  def mount(%{"dashboard_id" => dashboard_id, "id" => widget_id}, _session, socket) do
    {:ok,
     socket
     |> assign(section: :dashboard_widgets)
     |> assign_dashboard(dashboard_id)
     |> assign_widget(widget_id)
     |> assign(:page_title, "Add widget")
     |> assign_widgets()}
  end

  @impl true
  def mount(%{"id" => dashboard_id}, _session, socket) do
    {:ok,
     socket
     |> assign(section: :dashboard_widgets)
     |> assign_dashboard(dashboard_id)
     |> assign_empty_widget_instance()
     |> assign_widget()
     |> assign_widgets()}
  end

  @impl true
  def handle_params(%{"datasource_id" => datasource_id}, _url, socket) do
    {:noreply, socket |> assign_widgets(datasource_id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :add, %{"id" => widget_id}) do
    socket
    |> assign(:page_title, "Add widget")
    |> assign_widget_instance(widget_id)
  end

  defp apply_action(socket, _action, _params) do
    socket
  end

  defp assign_widget_instance(socket, widget_id) do
    widget = Widgets.get!(widget_id)

    socket
    |> assign(:widget_instance, widget |> build_widget_instance())
    |> assign(:datasource_id, widget.datasource_id)
  end

  def build_widget_instance(widget) do
    %WidgetInstance{
      name: widget.name,
      widget_id: widget.id,
      settings: Widget.settings(widget),
      enabled: true
    }
  end

  defp assign_widget(socket, widget_id) do
    socket
    |> assign(:widget, Widgets.get!(widget_id))
  end

  defp assign_widget(socket) do
    socket
    |> assign(:widget, nil)
  end

  defp assign_empty_widget_instance(socket) do
    socket
    |> assign(widget_instance: nil)
  end

  defp assign_widgets(socket) do
    # TODO: Assing widgets that are available
    # to the project datasources
    socket
    |> assign(widgets: Widgets.all())
  end

  defp assign_widgets(socket, datasource_id) do
    socket
    |> assign(widgets: Widgets.all(%{datasource_id: datasource_id}))
  end

  defp assign_dashboard(socket, dashboard_id) do
    {:ok, dashboard} = dashboard_id |> Dashboards.get_with_project()

    socket
    |> assign(dashboard: dashboard)
    |> assign(project: dashboard.project)
  end
end
