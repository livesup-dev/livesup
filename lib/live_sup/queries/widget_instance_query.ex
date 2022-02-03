defmodule LiveSup.Queries.WidgetInstanceQuery do
  alias LiveSup.Schemas.{WidgetInstance, Dashboard}
  alias LiveSup.Repo
  import Ecto.Query

  def all do
    base()
    |> Repo.all()
  end

  def get!(id) do
    query =
      from(
        wi in WidgetInstance,
        join: w in assoc(wi, :widget),
        join: di in assoc(wi, :datasource_instance),
        join: d in assoc(di, :datasource),
        where: wi.id == ^id,
        preload: [:widget, datasource_instance: {di, datasource: d}]
      )

    query |> Repo.one!()
  end

  def create(attrs) do
    %WidgetInstance{}
    |> WidgetInstance.changeset(attrs)
    |> Repo.insert()
  end

  def update(project, attrs) do
    project
    |> WidgetInstance.changeset(attrs)
    |> Repo.update()
  end

  def delete(project) do
    project
    |> Repo.delete()
  end

  def by_dashboard(%Dashboard{id: dashboard_id}) do
    dashboard_id |> by_dashboard
  end

  def by_dashboard(dashboard_id) do
    query =
      from(
        wi in WidgetInstance,
        join: dw in assoc(wi, :dashboards_widgets),
        join: w in assoc(wi, :widget),
        join: di in assoc(wi, :datasource_instance),
        join: d in assoc(di, :datasource),
        where:
          dw.dashboard_id == ^dashboard_id and
            w.enabled == true and wi.enabled == true,
        order_by: dw.order,
        preload: [:widget, datasource_instance: {di, datasource: d}]
      )

    query
    |> Repo.all()
  end

  # def with_dashboard(query \\ base()) do
  #   query
  #   |> join(:inner, [project], pg in ProjectGroup, as: :project_group)
  # end

  def base, do: from(WidgetInstance, as: :widget_instance)
end
