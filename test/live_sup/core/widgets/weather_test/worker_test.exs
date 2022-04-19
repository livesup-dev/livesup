defmodule LiveSup.Test.Core.Widgets.Weather.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.Weather.{Handler, Worker}
  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetData, WidgetManager, WorkerTaskSupervisor}

  describe "Chuck Norris Joke widget" do
    @describetag :widget
    @describetag :weather_widget

    @handler_response {:ok,
                       %{
                         condition: "Partly cloudy",
                         feelslike: 21.0,
                         is_day: 0,
                         location: "Mahon, Mahon",
                         temp: 21.0
                       }}

    @handler_error_response {:error, "Can't read the API"}

    @widget_instance %WidgetInstance{
      id: "bd62eea2-875a-4a86-b31b-c8a1983c1de4",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Weather.Worker",
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
      id: "ed640b39-cf82-4e3a-8504-b10fb5563279",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Weather.Worker",
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

      :ok
    end

    test "checking weather widget server" do
      with_mock Handler, get_data: fn _args -> @handler_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: %{
                   condition: "Partly cloudy",
                   feelslike: 21.0,
                   is_day: 0,
                   location: "Mahon, Mahon",
                   temp: 21.0
                 },
                 state: :ready,
                 title: "Weather",
                 updated_in_minutes: _
               } = data
      end
    end

    test "checking weather widget state with error" do
      with_mock Handler, get_data: fn _args -> @handler_error_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance_with_errror)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance_with_errror)

        assert %WidgetData{
                 data: %{error_description: "Can't read the API"},
                 state: :error,
                 title: "Weather",
                 updated_in_minutes: _
               } = data
      end
    end
  end
end
