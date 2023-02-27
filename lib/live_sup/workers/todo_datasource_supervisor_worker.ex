defmodule LiveSup.Workers.TodoDatasourceSupervisorWorker do
  alias LiveSup.Queries.TodoDatasourceQuery

  use Oban.Worker,
    queue: :todo_datasources,
    max_attempts: 1,
    unique: [fields: [:args, :worker], keys: [:todo_id]]

  @impl Oban.Worker
  def perform(_) do
    TodoDatasourceQuery.all()
    |> Enum.each(fn %{id: todo_datasource_id} ->
      %{todo_datasource_id: todo_datasource_id}
      |> LiveSup.Workers.TodoDatasourceWorker.new()
      |> Oban.insert()
    end)

    :ok
  end
end
