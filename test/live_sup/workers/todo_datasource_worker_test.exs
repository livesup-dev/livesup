defmodule LiveSup.Workers.TodoDatasourceWorkerTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  setup [
    :setup_user,
    :setup_project,
    :setup_github_datasource,
    :setup_todo,
    :setup_github_todo_datasource
  ]

  @tag :todo_datasource_worker
  test "execute datasource", %{todo_github_datasource: %{id: todo_datasource_id}} do
    # Oban.drain_queue(queue: :todo_datasources, with_recursion: true)
    assert :ok =
             perform_job(LiveSup.Workers.TodoDatasourceWorker, %{
               todo_datasource_id: todo_datasource_id
             })
  end
end
