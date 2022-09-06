defmodule LiveSup.Test.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  alias LiveSup.Core.{Comments, Tasks}
  alias LiveSup.Schemas.{TodoTask, User}

  def comment_fixture(%TodoTask{} = task, %User{} = user, comment \\ "my cool comment") do
    task
    |> Tasks.add_comment(user, comment)
    |> elem(1)
    |> Comments.get!()
  end
end
