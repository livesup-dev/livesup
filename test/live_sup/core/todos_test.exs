defmodule LiveSup.Test.Core.TodosTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  alias LiveSup.Core.Todos
  alias LiveSup.Schemas.Todo

  import LiveSup.Test.Setups

  describe "todos" do
    @describetag :todos

    @name "My Todo"
    @valid_attrs %{
      title: @name
    }
    @update_attrs %{title: "My Cool Todo"}
    @invalid_attrs %{title: nil}

    setup [:setup_user, :setup_project, :setup_todo]

    test "by_project/1 returns all todos", %{todo: todo, project: project} do
      todos = Todos.by_project(project)
      assert todos == [todo]
    end

    test "get!/1 returns the todo with given id", %{todo: todo} do
      assert Todos.get!(todo.id) == todo
    end

    test "create/1 with valid data creates a widget" do
      assert {:ok, %Todo{} = todo} = Todos.create(@valid_attrs)

      assert todo.title == "My Todo"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the widget", %{todo: todo} do
      assert {:ok, %Todo{} = todo} = Todos.update(todo, @update_attrs)
      assert todo.title == "My Cool Todo"
    end

    test "update/2 with invalid data returns error changeset", %{todo: todo} do
      assert {:error, %Ecto.Changeset{}} = Todos.update(todo, @invalid_attrs)
      assert todo == Todos.get!(todo.id)
    end

    test "delete/1 deletes the todo", %{todo: todo} do
      assert {:ok, %Todo{}} = Todos.delete(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get!(todo.id) end
    end

    test "change/1 returns a todo changeset", %{todo: todo} do
      assert %Ecto.Changeset{} = Todos.change(todo)
    end
  end
end
