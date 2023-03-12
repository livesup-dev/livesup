defmodule LiveSup.Tests.Queries.TaskQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.TaskQuery
  alias LiveSup.Core.Todos
  alias LiveSup.Test.TasksFixtures

  import LiveSup.Test.Setups

  setup [
    :setup_user_and_default_project,
    :setup_todo,
    :setup_github_datasource
  ]

  describe "getting tasks" do
    @describetag :tasks_query

    setup [
      :setup_task
    ]

    test "return all" do
      tasks = TaskQuery.all()

      assert length(tasks) == 1
    end
  end

  describe "creating a task" do
    @tag :task_query_create
    test "create/1", %{todo: %{id: todo_id, created_by_id: created_by_id}} do
      attrs = %{
        "title" => "this is the title",
        "description" => "alo?",
        "due_on" => "2022-09-06",
        "notes" => "some cool notes",
        "todo_id" => todo_id,
        "created_by_id" => created_by_id
      }

      {:ok, task} = TaskQuery.create(attrs)
      assert task.title == "this is the title"
      assert task.description == "alo?"
      assert task.due_on == ~U[2022-09-06 00:00:00Z]
    end

    @tag :task_query_upsert
    test "upsert/1", %{
      todo: %{
        id: todo_id,
        created_by_id: created_by_id
      },
      github_datasource_instance: %{id: datasource_instance_id}
    } do
      attrs = %{
        "title" => "this is the title",
        "description" => "alo?",
        "due_on" => "2022-09-06",
        "notes" => "some cool notes",
        "todo_id" => todo_id,
        "external_identifier" => "123",
        "datasource_instance_id" => datasource_instance_id,
        "created_by_id" => created_by_id
      }

      {:ok, task} = TaskQuery.create(attrs)
      assert task.title == "this is the title"
      assert task.external_identifier == "123"
      assert task.datasource_instance_id == datasource_instance_id
      assert task.completed == false

      task = TaskQuery.upsert!(Map.merge(attrs, %{"completed" => true, "title" => "new title"}))

      assert task.title == "new title"
      assert task.external_identifier == "123"
      assert task.datasource_instance_id == datasource_instance_id
      assert task.completed == true
    end
  end

  describe "managing tasks queries" do
    @describetag :tasks_query

    setup %{todo: todo} do
      task = TasksFixtures.task_fixture(todo)
      TasksFixtures.task_fixture(todo)

      {:ok, task: task}
    end

    test "delete todo's tasks", %{todo: %{id: todo_id}} do
      tasks = Todos.get_tasks(todo_id)

      assert length(tasks) == 2

      {_result, nil} =
        todo_id
        |> TaskQuery.delete_all()

      tasks = Todos.get_tasks(todo_id)
      assert Enum.empty?(tasks) == true
    end

    test "get_with_todo/1" do
      result = TaskQuery.get_with_todo("c4c46245-3a13-43f0-8a68-6a3c55ac823e")

      assert result == nil
    end

    test "get!/1 with a non existing task" do
      assert_raise Ecto.NoResultsError, fn ->
        TaskQuery.get!("2800e22e-ea11-4f23-8bf6-8bd2ddb4cf4c")
      end
    end

    test "complete!/1", %{task: task} do
      TaskQuery.complete!(task.id)
      task = TaskQuery.get!(task.id)
      assert task.completed == true
    end

    test "incomplete!/1", %{task: task} do
      TaskQuery.incomplete!(task.id)
      task = TaskQuery.get!(task.id)
      assert task.completed == false
    end

    test "get/1", %{task: task} do
      found_task = TaskQuery.get(task)
      assert found_task.description == task.description
    end

    test "get!/1", %{task: task} do
      found_task = TaskQuery.get!(task.id)
      assert found_task.description == task.description
    end

    test "update/2", %{task: task} do
      found_task = TaskQuery.get!(task.id)

      {:ok, _saved_task} = TaskQuery.update(found_task, %{description: "new description"})

      found_task = TaskQuery.get!(task.id)
      assert found_task.description == "new description"
    end
  end
end
