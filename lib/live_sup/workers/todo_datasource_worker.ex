defmodule LiveSup.Workers.TodoDatasourceWorker do
  use Oban.Worker,
    queue: :todo_datasources,
    max_attempts: 1,
    unique: [fields: [:args, :worker], keys: [:todo_datasource_id]]

  alias LiveSup.Queries.TodoDatasourceQuery
  alias LiveSup.Core.Todos

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"todo_datasource_id" => todo_datasource_id}}) do
    TodoDatasourceQuery.get!(todo_datasource_id)
    |> Todos.run_datasource()

    :ok
  end
end
