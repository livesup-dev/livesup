defmodule LiveSup.DataImporter.ProjectImporter do
  alias LiveSup.Core.{Projects, Dashboards, Datasources, Widgets}
  alias LiveSup.Schemas.{Project, WidgetInstance, DashboardWidget}

  def import(%{"projects" => projects} = data) do
    projects
    |> Enum.each(fn project_attrs ->
      project_attrs
      |> get_or_create_project()
      |> import_dashboards(project_attrs)
    end)

    data
  end

  def import(data), do: data

  defp get_or_create_project(%{"id" => id} = attrs) do
    Projects.get(id) || Projects.create_public_project(attrs)
  end

  defp import_dashboards({:ok, %Project{} = project}, %{"dashboards" => dashboards}) do
    dashboards
    |> Enum.each(fn dashboard_attrs ->
      project
      |> get_or_create_dashboard(dashboard_attrs)
      |> import_widget(dashboard_attrs)
    end)
  end

  defp import_dashboards(nil, _args), do: :ok
  defp import_dashboards({:ok, %Project{} = _project}, _args), do: :ok
  defp import_dashboards(%Project{} = project, args), do: import_dashboards({:ok, project}, args)

  def get_or_create_dashboard(project, %{"id" => id} = attrs) do
    case Dashboards.get(id) do
      {:error, :not_found} -> Dashboards.create(project, attrs)
      {:ok, dashboard} -> {:ok, dashboard}
    end
  end

  def import_widget({:ok, dashboard}, %{"widgets" => widgets}) do
    widgets
    |> Enum.each(fn widget_attrs ->
      %{"id" => widget_instance_id} = widget_attrs

      LiveSup.Core.Widgets.get_instance(widget_instance_id)
      |> add_widget(widget_attrs)
      |> add_widget_instance_to_dashboard(dashboard)
    end)
  end

  def import_widget({:ok, _dashboard}, _), do: true

  def add_widget(%WidgetInstance{} = widget_instance, _widget_attrs) do
    widget_instance
  end

  def add_widget(nil, widget_attrs) do
    create_widget_instance(widget_attrs)
  end

  def create_widget_instance(
        %{
          "datasource_slug" => datasource_slug,
          "widget_slug" => widget_slug,
          "id" => widget_instance_id
        } = attrs
      ) do
    settings = attrs["settings"] || %{}
    datasource = Datasources.get_by_slug!(datasource_slug)
    {:ok, datasource_instance} = Datasources.find_or_create_instance(datasource)
    widget = Widgets.get_by_slug!(widget_slug)

    widget_instance_attrs = Widgets.build_instance_attrs(widget, datasource_instance)

    widget_instance =
      Map.merge(widget_instance_attrs, %{
        settings: settings,
        id: widget_instance_id
      })

    {:ok, widget_instance} = Widgets.create_instance(widget_instance)

    widget_instance
  end

  def add_widget_instance_to_dashboard(widget_instance, dashboard) do
    case Dashboards.get_instance(dashboard, widget_instance) do
      nil ->
        dashboard
        |> Dashboards.add_widget(widget_instance)

      %DashboardWidget{} ->
        nil
    end
  end

  def find_or_create_widget_instance(_, _), do: :ok
end
