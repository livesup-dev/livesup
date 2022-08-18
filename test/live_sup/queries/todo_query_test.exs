defmodule LiveSup.Tests.Queries.TodoQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.TodoQuery
  alias LiveSup.Core.{Projects}

  import LiveSup.Test.Setups

  setup [
    :setup_user_and_default_project,
    :setup_todos
  ]

  describe "managing todos queries" do
    @describetag :todos_query

    test "delete project's todos", %{project: project} do
      {:ok, found_project} = Projects.get_with_todos(project.id)

      assert length(found_project.todos) == 2

      {_result, nil} =
        project
        |> TodoQuery.delete_all()

      {:ok, found_project} = Projects.get_with_todos(project.id)
      assert length(found_project.todos) == 0
    end

    test "return all" do
      todos = TodoQuery.all()

      assert length(todos) == 2
    end

    test "get/1", %{todos: [first_todo, _second_todo]} do
      todo = TodoQuery.get(first_todo.id)
      assert todo.title == first_todo.title

      todo = TodoQuery.get(first_todo)
      assert todo.title == first_todo.title
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
  end
end
