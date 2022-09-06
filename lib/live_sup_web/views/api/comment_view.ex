defmodule LiveSupWeb.Api.CommentView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.{CommentView, TaskView, UserView}

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      task: render_task(comment),
      created_by: render_created_by(comment),
      inserted_at: comment.inserted_at,
      updated_at: comment.updated_at
    }
  end

  defp render_created_by(%{
         created_by_id: created_by_id,
         created_by: %Ecto.Association.NotLoaded{}
       }) do
    %{
      created_by: %{
        id: created_by_id
      }
    }
  end

  defp render_created_by(%{created_by: created_by}) do
    render_one(created_by, UserView, "user.json")
  end

  defp render_task(%{task: %Ecto.Association.NotLoaded{}, task_id: task_id}) do
    %{
      task: %{id: task_id}
    }
  end

  defp render_task(%{task: task}) do
    render_one(task, TaskView, "task.json")
  end
end
