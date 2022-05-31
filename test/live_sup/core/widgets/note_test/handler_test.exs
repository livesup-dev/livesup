defmodule LiveSup.Test.Core.Widgets.Note.HandlerTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Widgets.Note.Handler
  alias LiveSup.Test.NotesFixtures

  describe "Managing Note Handler" do
    @describetag :widget
    @describetag :note_widget
    @describetag :note_handler

    setup [:setup_data]

    test "getting the note" do
      data =
        %{"note" => "my-cool-note"}
        |> Handler.get_data()

      assert {
               :ok,
               %{
                 content: "This is my note",
                 html_content: "<p>This is my note</p>",
                 title: nil
               }
             } = data
    end

    test "failing getting the note" do
      data =
        %{"note" => "bad-slug"}
        |> Handler.get_data()

      assert {:error, :note_not_found} = data
    end

    def setup_data(_) do
      note = NotesFixtures.note_fixture(%{slug: "my-cool-note", content: "This is my note"})

      %{note: note}
    end
  end
end
