defmodule LiveSup.Core.Todos.RunDatasourceTest do
  use LiveSup.DataCase, async: false
  import Mock
  alias LiveSup.Core.Todos
  alias LiveSup.Queries.TodoDatasourceQuery

  import LiveSup.Test.Setups

  alias LiveSup.Core.Datasources.GithubDatasource

  setup [
    :setup_default_bot,
    :setup_user,
    :setup_project,
    :setup_todo,
    :setup_github_datasource,
    :setup_github_todo_datasource
  ]

  @handler_response {
    :ok,
    [
      %{
        updated_at: ~U[2021-10-27 14:54:51Z],
        updated_at_ago: "6 hours ago",
        created_at: ~U[2021-10-27 14:54:51Z],
        created_at_ago: "6 hours ago",
        html_url: "https://github.com/phoenixframework/phoenix/pull/4565",
        title: "fix: mix phx.routes doc formatting",
        body: nil,
        state: "open",
        id: "767504535",
        number: 4565,
        merged: false,
        closed: false,
        repo: %{html_url: "https://github.com/StephaneRob/phoenix", name: "phoenix"},
        user: %{
          avatar_url: "https://avatars.githubusercontent.com/u/4135765?v=4",
          html_url: "https://github.com/StephaneRob",
          id: 4_135_765,
          login: "StephaneRob"
        }
      }
    ]
  }

  @tag :todos_run_datasource
  test "run datasource", %{
    todo_github_datasource:
      %{datasource_instance: %{id: datasource_instance_id}} = todo_github_datasource
  } do
    with_mock GithubDatasource,
      search_pull_requests: fn _owner, _repo, _params -> @handler_response end do
      %{todo: todo} = todo_github_datasource = TodoDatasourceQuery.get!(todo_github_datasource.id)
      {:ok, new_tasks} = Todos.run_datasource(todo_github_datasource)

      tasks = Todos.get_tasks(todo.id)
      assert length(new_tasks) == 1
      assert length(tasks) == 1

      first_task = tasks |> Enum.at(0)
      assert first_task.title == "fix: mix phx.routes doc formatting"
      assert first_task.description == nil
      assert first_task.datasource_instance_id == datasource_instance_id
      assert first_task.tags == ["github", "phoenix"]
      assert first_task.external_metadata != %{}
      assert first_task.external_identifier == "767504535"
      assert first_task.inserted_at == ~N[2021-10-27 14:54:51]
      assert first_task.updated_at == ~N[2021-10-27 14:54:51]

      todo_github_datasource = TodoDatasourceQuery.get!(todo_github_datasource.id)
      assert todo_github_datasource.last_run_at != nil

      # Re run the same datasource and check that the task is not duplicated
      {:ok, _new_tasks} = Todos.run_datasource(todo_github_datasource)

      tasks = Todos.get_tasks(todo.id)
      assert length(tasks) == 1
    end
  end
end
