defmodule LiveSup.Test.Core.Widgets.Note.WorkerTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Widgets.Note.Worker
  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetData, WidgetManager, WorkerTaskSupervisor}
  alias LiveSup.Test.NotesFixtures

  describe "Note worker" do
    @describetag :widget
    @describetag :note_widget

    @widget_instance %WidgetInstance{
      id: "c2e32eb3-3de4-40a1-9509-4c5503e344ee",
      settings: %{"note" => "my-cool-note"},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Note.Worker",
        settings: %{}
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    @widget_instance_with_errror %WidgetInstance{
      id: "1cf19c99-9f49-48c3-badd-e6e570fb7937",
      settings: %{"note" => "my-bad-note"},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Note.Worker",
        settings: %{}
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    setup do
      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
      setup_data()

      :ok
    end

    test "checking note widget server" do
      {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

      WorkerTaskSupervisor.wait_for_completion()

      data = Worker.get_data(@widget_instance)

      assert %LiveSup.Core.Widgets.WidgetData{
               data: %{
                 content: "This is my note",
                 html_content: "<p>This is my note</p>",
                 title: nil
               },
               state: :ready,
               title: "Notes",
               updated_in_minutes: _
             } = data
    end

    test "checking note widget state with error" do
      {:ok, _pid} = WidgetManager.start_widget(@widget_instance_with_errror)

      WorkerTaskSupervisor.wait_for_completion()

      data = Worker.get_data(@widget_instance_with_errror)

      assert %WidgetData{
               data: %{error_description: :note_not_found},
               state: :error,
               title: "Notes",
               updated_in_minutes: _
             } = data
    end

    def setup_data() do
      NotesFixtures.note_fixture(%{slug: "my-cool-note", content: "This is my note"})
    end
  end
end
