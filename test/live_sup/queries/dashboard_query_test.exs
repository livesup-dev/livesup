defmodule LiveSup.Tests.Queries.DashboardQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.DashboardQuery
  alias LiveSup.Core.{Projects, Dashboards}

  import LiveSup.Test.Setups

  setup [
    :setup_user_and_default_project
  ]

  describe "managing dashboard queries" do
    @describetag :dashboard_query

    test "delete project's dashboards", %{project: project} do
      {:ok, found_project} = Projects.get_with_dashboards(project.id)

      %{id: dashboard_id} =
        found_project.dashboards
        |> Enum.at(0)

      widgets_instances = Dashboards.widgets_instances(dashboard_id)

      assert length(found_project.dashboards) == 1
      assert length(widgets_instances) == 2

      {result, nil} =
        project
        |> DashboardQuery.delete_all()

      widgets_instances_after_deleted = Dashboards.widgets_instances(dashboard_id)
      assert result == 1
      assert widgets_instances_after_deleted == []
    end
  end
end
