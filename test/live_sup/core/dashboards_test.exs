defmodule LiveSup.Test.Core.DashboardsTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Core.Dashboards
  alias LiveSup.Schemas.Dashboard
  import LiveSup.Test.Setups

  @valid_attrs %{name: "My cool dash", labels: [], settings: %{}, default: true}
  @update_attrs %{name: "My new cool dash", labels: [], settings: %{}, default: false}
  @invalid_attrs %{name: nil}

  def initialize(context) do
    context
    |> Enum.into(%{dashboard_attrs: @valid_attrs})
  end

  setup [:initialize, :setup_dashboard_with_widgets]

  describe "Dashboards" do
    @describetag :dashboards

    test "all/1 returns all projects", %{project: project, dashboard: dashboard} do
      assert Dashboards.by_project(project) == [dashboard]
    end

    test "get!/1 returns the dashboard with given id", %{dashboard: dashboard} do
      assert Dashboards.get!(dashboard.id) == dashboard
    end

    test "create/1 with valid data creates a dashboard", %{project: project} do
      assert {:ok, %Dashboard{} = dashboard} =
               Dashboards.create(project, %{
                 name: "New dashboard",
                 labels: [],
                 settings: %{},
                 default: true
               })

      assert dashboard.default == true
      assert dashboard.labels == []
      assert dashboard.name == "New dashboard"
      assert dashboard.settings == %{}
    end

    test "create/1 with invalid data returns error changeset", %{project: project} do
      assert {:error, %Ecto.Changeset{}} = Dashboards.create(project, @invalid_attrs)
    end

    test "update/2 with valid data updates the dashboard", %{dashboard: dashboard} do
      assert {:ok, %Dashboard{} = dashboard} = Dashboards.update(dashboard, @update_attrs)
      assert dashboard.default == false
      assert dashboard.labels == []
      assert dashboard.name == "My new cool dash"
      assert dashboard.settings == %{}
    end

    test "update/2 with invalid data returns error changeset", %{dashboard: dashboard} do
      assert {:error, %Ecto.Changeset{}} = Dashboards.update(dashboard, @invalid_attrs)
      assert dashboard == Dashboards.get!(dashboard.id)
    end

    test "delete/1 deletes the dashboard", %{dashboard: dashboard} do
      assert {:ok, %Dashboard{}} = Dashboards.delete(dashboard)
      assert_raise Ecto.NoResultsError, fn -> Dashboards.get!(dashboard.id) end
    end

    test "change/1 returns a dashboard changeset", %{dashboard: dashboard} do
      assert %Ecto.Changeset{} = Dashboards.change(dashboard)
    end

    test "update_widget_instance_order/3 change the widget instance order", %{
      dashboard: %{id: dashboard_id},
      widgets_instances: widgets_instances
    } do
      %{id: widget_instance_id} = widgets_instances |> Enum.at(0)

      %{order: existing_order} =
        LiveSup.Queries.DashboardWidgetQuery.by_dashboard_and_widget(
          dashboard_id,
          widget_instance_id
        )

      assert existing_order == 0

      {:ok, _updated_widget} =
        Dashboards.update_widget_instance_order(dashboard_id, widget_instance_id, 3)

      %{order: order} =
        LiveSup.Queries.DashboardWidgetQuery.by_dashboard_and_widget(
          dashboard_id,
          widget_instance_id
        )

      assert order == 3
    end
  end
end
