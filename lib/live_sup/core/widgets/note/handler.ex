defmodule LiveSup.Core.Widgets.Note.Handler do
  alias LiveSup.Queries.NoteQuery

  def get_data(%{"note" => note_slug}) do
    note_slug
    |> NoteQuery.get_by_slug()
    |> parse_markdown()
  end

  defp parse_markdown(nil) do
    {:error, :note_not_found}
  end

  defp parse_markdown(%{content: content, title: title}) do
    {:ok, html_content, []} = Earmark.as_html(content, compact_output: true)

    note = %{
      content: content,
      html_content: html_content,
      title: title
    }

    {:ok, note}
  end
end
