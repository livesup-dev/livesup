defmodule LiveSup.Tests.Queries.TodoQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.TodoQuery
  alias LiveSup.Core.{Projects}
  alias LiveSup.Test.TodosFixtures

  import LiveSup.Test.Setups

  setup [
    :setup_user_and_default_project,
    :setup_todos,
    :setup_task
  ]

  describe "managing todos queries" do
    @describetag :todos_query

    test "delete project's todos", %{project: project} do
      {:ok, found_project} = Projects.get_with_todos(project.id)

      assert length(found_project.todos) == 3

      {_result, nil} =
        project
        |> TodoQuery.delete_all()

      {:ok, found_project} = Projects.get_with_todos(project.id)
      assert Enum.empty?(found_project.todos) == true
    end

    test "by_project/2", %{project: project} do
      todos = TodoQuery.by_project(project)

      assert length(todos) == 3
    end

    test "by_project/2 and archived", %{project: project} do
      TodosFixtures.todo_archived_fixture(project)

      todos = TodoQuery.by_project(project, %{archived: true})

      assert length(todos) == 1
    end

    test "return all" do
      todos = TodoQuery.all()

      assert length(todos) == 3
    end

    @tag :get_todo
    test "get/1", %{todo: todo} do
      todo = TodoQuery.get(todo.id)
      assert todo.title == todo.title
      assert todo.open_tasks_count == 1
      assert todo.completed_tasks_count == 0

      todo = TodoQuery.get(todo)
      assert todo.title == todo.title
    end

    test "get!/1", %{todos: [first_todo, _second_todo]} do
      todo = TodoQuery.get!(first_todo.id)
      assert todo.title == first_todo.title
    end

    test "update/2", %{todos: todos} do
      first_todo =
        todos
        |> List.first()

      todo = TodoQuery.get!(first_todo.id)

      {:ok, _saved_user} = TodoQuery.update(todo, %{title: "new title"})

      todo = TodoQuery.get!(first_todo.id)
      assert todo.title == "new title"
    end

    test "archive/1", %{todos: todos} do
      first_todo =
        todos
        |> List.first()

      {:ok, todo} = TodoQuery.archive(first_todo)

      archived_todo = TodoQuery.get!(todo)

      assert archived_todo.archived == true

      assert NaiveDateTime.diff(NaiveDateTime.utc_now(), archived_todo.archived_at, :second) <= 1
    end
  end
end
