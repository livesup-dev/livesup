defmodule LiveSup.DataImporter.NoteImporter do
  alias LiveSup.Queries.NoteQuery
  import Logger

  def import(%{"notes" => notes}) do
    debug("NoteImporter:import")

    notes
    |> Enum.each(fn note_attrs ->
      note_attrs
      |> get_or_create()
    end)
  end

  def import(data), do: data

  defp get_or_create(attrs) do
    {:ok, note} = NoteQuery.create(attrs)
    note
  end
end
