defmodule LiveSup.Core.Dashboards do
  @moduledoc """
  The Dashboards context.
  """

  alias LiveSup.Schemas.{Dashboard, Project, WidgetInstance}
  alias LiveSup.Queries.{DashboardQuery, DashboardWidgetQuery, WidgetInstanceQuery}
  alias LiveSup.Helpers.StringHelper

  @doc """
  Returns the list of dashboards.

  ## Examples

      iex> all()
      [%Dashboard{}, ...]

  """
  defdelegate by_project(project_id), to: DashboardQuery

  def get(id) do
    id
    |> DashboardQuery.get()
    |> found()
  end

  def get_with_project(id) do
    id
    |> DashboardQuery.get_with_project()
    |> found()
  end

  defp found(nil), do: {:error, :not_found}
  defp found(resource), do: {:ok, resource}

  defdelegate get!(id), to: DashboardQuery

  @doc """
  Creates a project.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Dashboard{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) when is_map(attrs) do
    attrs
    |> DashboardQuery.create()
  end

  def create(%Project{id: project_id}, attrs \\ %{}) do
    attrs
    |> StringHelper.keys_to_strings()
    |> Enum.into(%{"project_id" => project_id})
    |> DashboardQuery.create()
  end

  @doc """
  Updates a dashboard.

  ## Examples

      iex> update(dashboard, %{field: new_value})
      {:ok, %Dashboard{}}

      iex> update(dashboard, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Dashboard{} = dashboard, attrs) do
    dashboard
    |> DashboardQuery.update(attrs)
  end

  @doc """
  Deletes a dashboard.

  ## Examples

      iex> delete(dashboard)
      {:ok, %Dashboard{}}

      iex> delete(dashboard)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Dashboard{} = dashboard) do
    dashboard
    |> DashboardQuery.delete()
  end

  def delete_all(%Project{} = project) do
    project
    |> DashboardQuery.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dashboard changes.

  ## Examples

      iex> change(dashboard)
      %Ecto.Changeset{data: %Dashboard{}}

  """
  def change(%Dashboard{} = dashboard, attrs \\ %{}) do
    Dashboard.changeset(dashboard, attrs)
  end

  def widgets_instances(%Dashboard{id: dashboard_id}) do
    dashboard_id |> widgets_instances()
  end

  def widgets_instances(dashboard_id) do
    dashboard_id |> WidgetInstanceQuery.by_dashboard()
  end

  def add_widget(%Dashboard{} = dashboard, %WidgetInstance{} = widget_instance) do
    %{
      dashboard_id: dashboard.id,
      widget_instance_id: widget_instance.id
    }
    |> DashboardWidgetQuery.create()
  end

  def add_widgets(%Dashboard{} = dashboard, widget_instances) do
    widget_instances
    |> Enum.each(fn widget_instance ->
      %{
        dashboard_id: dashboard.id,
        widget_instance_id: widget_instance.id
      }
      |> DashboardWidgetQuery.create!()
    end)
  end

  def get_instance(%Dashboard{id: dashboard_id}, %WidgetInstance{id: widget_instance_id}) do
    dashboard_id
    |> DashboardWidgetQuery.by_dashboard_and_widget(widget_instance_id)
  end

  def default(%Project{} = project) do
    project |> DashboardQuery.default()
  end

  def update_widget_instance_order(dashboard_id, widget_instance_id, order) do
    dashboard_widget =
      DashboardWidgetQuery.by_dashboard_and_widget(dashboard_id, widget_instance_id)

    DashboardWidgetQuery.update_order(dashboard_widget, order)
  end
end
