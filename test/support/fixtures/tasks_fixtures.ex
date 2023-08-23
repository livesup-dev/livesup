defmodule LiveSup.Test.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Todos` context.
  """

  alias LiveSup.Queries.TaskQuery
  alias LiveSup.Schemas.Todo
  alias LiveSup.Schemas.TodoTaskPriority

  def tasks_fixture(count, %Todo{} = todo, attrs \\ %{}) do
    Enum.map(1..count, fn _ ->
      task_fixture(todo, attrs)
    end)
  end

  def task_fixture(%Todo{} = todo, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(default_attrs(todo))

    TaskQuery.create!(attrs)
    |> TaskQuery.get!()
  end

  defp default_attrs(%{id: todo_id, created_by_id: created_by_id}) do
    %{
      title: "Some generic title - #{System.unique_integer()}",
      description: "Some generic description - #{System.unique_integer()}",
      todo_id: todo_id,
      created_by_id: created_by_id
    }
  end
end
