defmodule LiveSup.Queries.TaskQuery do
  import Ecto.Query

  alias LiveSup.Schemas.Todo
  alias LiveSup.Schemas.TodoTask
  alias LiveSup.Repo

  def search(params \\ %{}) do
    base()
    |> where(^filter_where(params))
    |> limit(^filter_limit(params))
    |> order_by(^filter_order_by(params))
    |> Repo.all()
  end

  defp filter_order_by(%{order_by: :updated_at_desc}),
    do: [desc: dynamic([t], t.updated_at)]

  defp filter_order_by(%{order_by: :updated_at_asc}),
    do: [asc: dynamic([t], t.updated_at)]

  defp filter_order_by(%{query: ""}), do: []

  defp filter_order_by(%{query: value}),
    do: [
      desc:
        dynamic(
          [t],
          fragment(
            "ts_rank_cd(searchable, websearch_to_tsquery(?), 4)",
            ^value
          )
        )
    ]

  defp filter_order_by(_), do: []

  defp filter_limit(%{limit: limit}), do: limit
  defp filter_limit(_), do: 100

  def filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {:completed, value}, dynamic ->
        dynamic([tasks: t], ^dynamic and t.completed == ^value)

      {:todo, %{id: todo_id}}, dynamic ->
        dynamic([tasks: t], ^dynamic and t.todo_id == ^todo_id)

      {:query, ""}, dynamic ->
        dynamic

      {:query, value}, dynamic ->
        dynamic(
          [tasks: t],
          ^dynamic and
            fragment(
              "searchable @@ websearch_to_tsquery(?)",
              ^value
            )
        )

      {_, _}, dynamic ->
        # Not a where parameter
        dynamic
    end)
  end

  def all do
    base()
    |> Repo.all()
  end

  def by_todo(todo, filters \\ [])

  def by_todo(%Todo{id: todo_id}, filters) do
    todo_id
    |> by_todo(filters)
  end

  def by_todo(todo_id, filters) when is_binary(todo_id) do
    base()
    |> where([p], p.todo_id == ^todo_id)
    |> (fn query ->
          case Keyword.has_key?(filters, :completed) do
            true -> where(query, [p], p.completed == ^filters[:completed])
            false -> query
          end
        end).()
    |> (fn query ->
          case Keyword.has_key?(filters, :limit) do
            true -> limit(query, ^filters[:limit])
            false -> query
          end
        end).()
    |> order_by([task], asc: task.completed, desc: task.inserted_at)
    |> Repo.all()
  end

  def get!(todo_task, params \\ [])

  def get!(%TodoTask{id: todo_id}, params) do
    base_query =
      params
      |> Keyword.get(:base, base())

    base_query
    |> Repo.get!(todo_id)
  end

  def get!(id, params) do
    get!(%TodoTask{id: id}, params)
  end

  @spec get_with_todo(String.t()) :: {:ok, TodoTask.t()} | nil
  def get_with_todo(id) do
    base()
    |> join(:inner, [d], p in Todo, on: d.todo_id == p.id)
    |> Repo.get(id)
  end

  def get(%TodoTask{id: todo_id}) do
    base()
    |> Repo.get(todo_id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def create(attrs) do
    %TodoTask{}
    |> TodoTask.create_changeset(attrs)
    |> Repo.insert()
  end

  def create!(attrs) do
    %TodoTask{}
    |> TodoTask.create_changeset(attrs)
    |> Repo.insert!()
  end

  def update(%TodoTask{} = model, attrs) do
    model
    |> TodoTask.update_changeset(attrs)
    |> Repo.update()
  end

  def update!(%TodoTask{} = model, attrs) do
    model
    |> TodoTask.update_changeset(attrs)
    |> Repo.update!()
  end

  def delete(%TodoTask{} = model) do
    model
    |> Repo.delete()
  end

  def delete_all(%Todo{id: todo_id}) do
    query =
      from(
        d in TodoTask,
        where: d.todo_id == ^todo_id
      )

    query
    |> Repo.delete_all()
  end

  def delete_all(todo_id) when is_binary(todo_id) do
    %Todo{id: todo_id}
    |> delete_all
  end

  def delete_all() do
    Repo.delete_all(TodoTask)
  end

  def complete!(task_id) when is_binary(task_id) do
    get!(task_id)
    |> update!(%{completed: true, completed_at: DateTime.utc_now()})
  end

  def incomplete!(task_id) when is_binary(task_id) do
    get!(task_id)
    |> update!(%{completed: false, completed_at: nil})
  end

  def upsert!(attrs) do
    # Make sure we have all the keys converted to atoms
    attrs =
      attrs
      |> Palette.Utils.StringHelper.keys_to_atoms()

    %TodoTask{}
    |> TodoTask.create_changeset(attrs)
    |> Repo.insert!(
      on_conflict: [
        set: [
          completed: attrs[:completed],
          title: attrs[:title],
          description: attrs[:description]
        ]
      ],
      conflict_target: [:external_identifier, :datasource_instance_id]
    )
  end

  def base(params \\ []) do
    preload =
      params
      |> Keyword.get(:preload, [:todo, :assigned_to, :created_by, :comments])

    from(TodoTask, as: :tasks, preload: ^preload)
  end
end
