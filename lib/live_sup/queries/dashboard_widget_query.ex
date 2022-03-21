defmodule LiveSup.Queries.DashboardWidgetQuery do
  alias LiveSup.Schemas.{DashboardWidget}
  alias LiveSup.Repo

  import Ecto.Query

  def all do
    base()
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def create!(attrs) do
    %DashboardWidget{}
    |> DashboardWidget.changeset(attrs)
    |> Repo.insert!()
  end

  def create(attrs) do
    %DashboardWidget{}
    |> DashboardWidget.changeset(attrs)
    |> Repo.insert()
  end

  def update(model, attrs) do
    model
    |> DashboardWidget.changeset(attrs)
    |> Repo.update()
  end

  def update_order(%DashboardWidget{} = dashboard_widget, order) do
    dashboard_widget
    |> DashboardWidget.changeset(%{order: order})
    |> Repo.update()
  end

  def by_dashboard_and_widget!(dashboard_id, widget_instance_id) do
    base()
    |> where(
      [dw],
      dw.dashboard_id == ^dashboard_id and dw.widget_instance_id == ^widget_instance_id
    )
    |> Repo.one!()
  end

  def by_dashboard_and_widget(dashboard_id, widget_instance_id) do
    base()
    |> where(
      [dw],
      dw.dashboard_id == ^dashboard_id and dw.widget_instance_id == ^widget_instance_id
    )
    |> Repo.one()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def base, do: from(DashboardWidget, as: :dashboard_widget)
end
