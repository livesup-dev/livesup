defmodule LiveSup.Test.Core.Widgets.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.ChuckNorrisJoke.{Worker, Handler}
  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetManager, WidgetData, WorkerTaskSupervisor}

  describe "Chuck Norris Joke widget" do
    @describetag :widget
    @describetag :chuck_widget

    @widget_instance %WidgetInstance{
      id: "e15638c7-c777-4531-997a-8f9ce971ff08",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.ChuckNorrisJoke.Worker"
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    @handler_response {
      :ok,
      "Chuck Norris smokes chains."
    }

    setup do
      WidgetManager.stop_widgets()

      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      :ok
    end

    test "checking chuck norris server state" do
      with_mock Handler, get_data: fn -> @handler_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %WidgetData{
                 data: "Chuck Norris smokes chains.",
                 state: :ready,
                 title: "Chuck Norris's jokes",
                 updated_in_minutes: _
               } = data
      end
    end
  end
end
