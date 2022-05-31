defmodule LiveSup.Test.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Notes` context.
  """

  alias LiveSup.Queries.NoteQuery

  def note_fixture(attrs \\ %{}) do
    attrs
    |> NoteQuery.create()
    |> elem(1)
  end
end
