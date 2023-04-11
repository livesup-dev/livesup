defmodule LiveSupWeb.Api.CommentController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.{Comments, Tasks}
  alias LiveSup.Schemas.Comment

  def index(conn, %{"task_id" => task_id}) do
    comments = task_id |> Comments.by_task()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{
        "task_id" => task_id,
        "comment" => comment_params
      }) do
    current_user = conn.assigns.current_user
    task = Tasks.get!(task_id)
    comment_body = Map.get(comment_params, "body", nil)

    with {:ok, %Comment{} = comment} <-
           Tasks.add_comment(task, current_user, comment_body) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/comments/#{comment.id}")
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get!(id)

    with {:ok, %Comment{} = comment} <-
           Comments.update(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get!(id)

    with {:ok, %Comment{}} <- Comments.delete(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
