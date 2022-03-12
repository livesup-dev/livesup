defmodule LiveSup.Test.Setups do
  alias LiveSup.Test.{DatasourcesFixtures, ProjectsFixtures, DashboardsFixtures, GroupsFixtures}

  def setup_dashboard(context) do
    project =
      context[:project] ||
        ProjectsFixtures.project_fixture(get_param(context, :project_attrs))

    dashboard =
      project
      |> DashboardsFixtures.dashboard_fixture(get_param(context, :dashboard_attrs))

    context
    |> add_to_context(%{project: project, dashboard: dashboard})
  end

  def setup_datasource(context) do
    datasource = DatasourcesFixtures.datasource_fixture(context)

    context
    |> add_to_context(%{datasource: datasource})
  end

  def setup_project(context) do
    project = ProjectsFixtures.project_fixture()

    context
    |> add_to_context(%{project: project})
  end

  def setup_groups(context) do
    admin_group = GroupsFixtures.administrator_group_fixture()
    all_users_group = GroupsFixtures.all_users_group_fixture()

    context
    |> add_to_context(%{admin_group: admin_group, all_users_group: all_users_group})
  end

  def setup_default_internal_project(context) do
    project = ProjectsFixtures.internal_default_project_fixture()

    context
    |> add_to_context(%{project: project})
  end

  def setup_dashboard_with_widgets(context) do
    context = context |> setup_dashboard()

    widgets_instances =
      DatasourcesFixtures.datasource_fixture()
      |> build_widgets_instances()

    context[:dashboard]
    |> LiveSup.Core.Dashboards.add_widgets(widgets_instances)

    context
    |> add_to_context(%{widgets_instances: widgets_instances})
  end

  def setup_user(context) do
    context
    |> add_to_context(%{user: LiveSup.Test.AccountsFixtures.user_fixture()})
  end

  def setup_user_with_groups(%{all_users_group: _, admin_group: _} = context) do
    context =
      context
      |> add_to_context(%{user: LiveSup.Test.AccountsFixtures.user_fixture()})

    LiveSup.Core.Groups.add_user(context[:user], context[:all_users_group])

    context
  end

  def setup_user_with_groups(context) do
    context =
      context
      |> setup_groups()

    context =
      context
      |> add_to_context(%{user: LiveSup.Test.AccountsFixtures.user_fixture()})

    LiveSup.Core.Groups.add_user(context[:user], context[:all_users_group])

    context
  end

  def setup_user_and_default_project(context) do
    context =
      context
      |> setup_user()
      |> setup_groups()
      |> setup_default_internal_project()
      |> setup_dashboard_with_widgets()

    LiveSup.Core.Groups.add_project(context[:project], context[:admin_group])
    LiveSup.Core.Groups.add_project(context[:project], context[:all_users_group])
    LiveSup.Core.Groups.add_user(context[:user], context[:all_users_group])

    context
  end

  def setup_admin_user_and_groups(context) do
    context = context |> setup_user()

    LiveSup.Core.Groups.add_user(context[:user], context[:admin_group])
    LiveSup.Core.Groups.add_user(context[:user], context[:all_users_group])

    context
  end

  defp build_widgets_instances(datasource) do
    datasource_instance =
      datasource
      |> LiveSup.Test.DatasourcesFixtures.datasource_instance_fixture()

    Enum.map([0, 1], fn _ ->
      datasource
      |> LiveSup.Test.WidgetsFixtures.widget_fixture()
      |> LiveSup.Core.Widgets.create_instance(datasource_instance)
      |> elem(1)
    end)
  end

  defp add_to_context(context, attrs) do
    context
    |> Enum.into(attrs)
  end

  defp get_param(context, key, default \\ %{}) do
    Map.get(context, key, default)
  end
end
