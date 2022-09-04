defmodule LiveSup.Test.Core.TasksTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Core.Tasks
  import LiveSup.Test.Setups

  describe "tasks" do
    @describetag :tasks

    setup [:setup_user, :setup_project, :setup_task]

    test "by_todo/0 returns all tasks by todo", %{todo: todo, task: task} do
      assert Tasks.by_todo(todo) == [task]
    end

    test "get!/1 returns the task with given id", %{task: task} do
      assert Tasks.get!(task.id) == task
    end

    test "complete!", %{task: %{id: task_id}} do
      Tasks.complete!(task_id)
      completed_task = Tasks.get!(task_id)
      assert completed_task.completed == true
    end

    test "incomplete!", %{task: %{id: task_id}} do
      Tasks.incomplete!(task_id)
      completed_task = Tasks.get!(task_id)
      assert completed_task.completed == false
    end

    @tag :emi
    test "add_comment", %{task: task, user: user} do
      {:ok, comment} = Tasks.add_comment(task, user, "This is my cool comment")
      found_task = Tasks.get_with_comments!(task)
      assert length(found_task.comments) == 1

      [first_comment] = found_task.comments

      assert first_comment == comment
    end
  end
end
