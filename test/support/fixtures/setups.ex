defmodule LiveSup.Test.Setups do
  @moduledoc """
    Module used for tests purposed. It comntains many different type of initializations

    ## Examples

        setup [:setup_user, :setup_project]
  """
  alias LiveSup.Test.{
    TodosFixtures,
    DatasourcesFixtures,
    ProjectsFixtures,
    DashboardsFixtures,
    GroupsFixtures,
    TasksFixtures,
    CommentsFixtures
  }

  alias LiveSup.Core.{Groups, Dashboards}

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

  def setup_github_datasource(context) do
    datasource = DatasourcesFixtures.add_github_datasource()

    datasource_instance =
      datasource
      |> LiveSup.Test.DatasourcesFixtures.datasource_instance_fixture()

    context
    |> add_to_context(%{
      github_datasource: datasource,
      github_datasource_instance: datasource_instance
    })
  end

  def setup_project(context) do
    project = ProjectsFixtures.project_fixture()

    context
    |> add_to_context(%{project: project})
  end

  def setup_todo(context) do
    todo =
      TodosFixtures.todo_fixture(context[:project], %{
        author_id: context[:user].id,
        created_by_id: context[:user].id
      })

    context
    |> add_to_context(%{todo: todo})
  end

  def setup_todo_datasource(%{todo: todo, datasource: datasource} = context) do
    todo_datasource = TodosFixtures.todo_datasource(todo, datasource)

    context
    |> add_to_context(%{todo_datasource: todo_datasource})
  end

  def setup_github_todo_datasource(%{todo: todo, github_datasource: datasource} = context) do
    todo_datasource = TodosFixtures.todo_datasource(todo, datasource)

    context
    |> add_to_context(%{todo_github_datasource: todo_datasource})
  end

  def setup_task(context) do
    context = context |> manage_todo()

    task =
      context
      |> Map.get(:todo)
      |> TasksFixtures.task_fixture()

    context
    |> add_to_context(%{task: task})
  end

  def setup_comments(context) do
    comment1 =
      context
      |> Map.get(:task)
      |> CommentsFixtures.comment_fixture(context[:user])

    comment2 =
      context
      |> Map.get(:task)
      |> CommentsFixtures.comment_fixture(context[:user])

    context
    |> add_to_context(%{comments: [comment1, comment2]})
  end

  def setup_comment(context) do
    comment =
      context
      |> Map.get(:task)
      |> CommentsFixtures.comment_fixture(context[:user])

    context
    |> add_to_context(%{comment: comment})
  end

  defp manage_todo(%{todo: _todo} = context), do: context

  defp manage_todo(context) do
    todo = context |> setup_todo() |> Map.get(:todo)

    context
    |> add_to_context(%{todo: todo})
  end

  def setup_todos(context) do
    todo1 = TodosFixtures.todo_fixture(context[:project], %{author_id: context[:user].id})
    todo2 = TodosFixtures.todo_fixture(context[:project], %{author_id: context[:user].id})

    context
    |> add_to_context(%{todos: [todo1, todo2]})
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
    |> Dashboards.add_widgets(widgets_instances)

    context
    |> add_to_context(%{widgets_instances: widgets_instances})
  end

  def setup_user(context) do
    context
    |> add_to_context(%{user: LiveSup.Test.AccountsFixtures.user_fixture()})
  end

  def setup_default_bot(context) do
    context
    |> add_to_context(%{bot: LiveSup.Test.AccountsFixtures.default_bot_fixture()})
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

    Groups.add_project(context[:project], context[:admin_group])
    Groups.add_project(context[:project], context[:all_users_group])
    Groups.add_user(context[:user], context[:all_users_group])

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
