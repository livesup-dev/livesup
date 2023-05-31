defmodule LiveSup.DataImporter.NoteImporter do
  alias LiveSup.Queries.NoteQuery

  def perform(%{"notes" => notes} = data) do
    notes
    |> Enum.each(fn note_attrs ->
      note_attrs
      |> create()
    end)

    data
  end

  def perform(data) do
    data
  end

  defp create(attrs) do
    {:ok, note} = NoteQuery.create(attrs)
    note
  end
end
