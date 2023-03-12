defmodule LiveSup.Workers.TodoDatasourceWorkerSupervisorTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  setup [:setup_user, :setup_project, :setup_datasource, :setup_todo, :setup_todo_datasource]

  @tag :todo_datasource_worker_supervisor
  test "execute datasource", %{todo_datasource: %{id: todo_datasource_id}} do
    Oban.Testing.with_testing_mode(:manual, fn ->
      assert :ok = perform_job(LiveSup.Workers.TodoDatasourceSupervisorWorker, %{})

      assert_enqueued(
        worker: LiveSup.Workers.TodoDatasourceWorker,
        args: %{todo_datasource_id: todo_datasource_id},
        queue: :todo_datasources
      )
    end)
  end
end
