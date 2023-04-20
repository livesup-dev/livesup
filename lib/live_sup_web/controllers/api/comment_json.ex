defmodule LiveSupWeb.Api.CommentJSON do
  alias LiveSupWeb.Api.{TaskJSON, UserJSON}
  alias LiveSup.Schemas.Comment

  def index(%{comments: comments}) do
    %{data: for(comment <- comments, do: data(comment))}
  end

  def show(%{comment: comment}) do
    %{data: data(comment)}
  end

  def data(%Comment{} = comment) do
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
    UserJSON.data(created_by)
  end

  defp render_task(%{task: %Ecto.Association.NotLoaded{}, task_id: task_id}) do
    %{
      task: %{id: task_id}
    }
  end

  defp render_task(%{task: task}) do
    TaskJSON.data(task)
  end
end
