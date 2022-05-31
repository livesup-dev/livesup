defmodule LiveSup.DataImporter.NoteImporter do
  alias LiveSup.Queries.NoteQuery
  import Logger

  def import(%{"notes" => notes} = data) do
    debug("NoteImporter:import")

    notes
    |> Enum.each(fn note_attrs ->
      note_attrs
      |> create()
    end)

    data
  end

  def import(data) do
    debug("NoteImporter:no-data")

    data
  end

  defp create(attrs) do
    {:ok, note} = NoteQuery.create(attrs)
    note
  end
end
