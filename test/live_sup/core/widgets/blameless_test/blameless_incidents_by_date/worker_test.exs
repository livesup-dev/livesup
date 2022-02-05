defmodule LiveSup.Test.Core.Widgets.Blameless.IncidentsByDate.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.Blameless.IncidentsByDate.{
    Worker,
    Handler
  }

  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetManager, WidgetData, WorkerTaskSupervisor}

  describe "Blameless current incidents widget" do
    @describetag :widget
    @describetag :blameless_last_incidents_widget

    @widget_instance %WidgetInstance{
      id: "cb3ee793-d45e-4e54-8dda-c56d4ce02f6e",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Blameless.IncidentsByDate.Worker"
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{
          "client_id" => "xxx",
          "client_secret" => "xxx",
          "audience" => "xxx",
          "limit" => 2
        },
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{
            "client_id" => %{
              "type" => "string",
              "required" => true
            },
            "client_secret" => %{
              "type" => "string",
              "required" => true
            },
            "audience" => %{
              "type" => "string",
              "required" => true
            },
            "limit" => %{
              "type" => "int",
              "default_value" => "5",
              "required" => true
            }
          }
        }
      }
    }

    @handler_response {
      :ok,
      [
        %{created_at: "2021/7/12", type: "Widgets", value: 1},
        %{created_at: "2021/7/12", type: "Widgets", value: 1},
        %{created_at: "2021/6/12", type: "Datasources", value: 1},
        %{created_at: "2021/4/12", type: "Widget", value: 1},
        %{created_at: "2021/4/12", type: "Datasources", value: 1},
        %{created_at: "2021/4/12", type: "Datasources", value: 1}
      ]
    }

    setup do
      WidgetManager.stop_widgets()

      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      :ok
    end

    test "checking blameless last incidents server state" do
      with_mock Handler, get_data: fn _args -> @handler_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %WidgetData{
                 data: [
                   %{created_at: "2021/7/12", type: "Widgets", value: 1},
                   %{created_at: "2021/7/12", type: "Widgets", value: 1},
                   %{created_at: "2021/6/12", type: "Datasources", value: 1},
                   %{created_at: "2021/4/12", type: "Widget", value: 1},
                   %{created_at: "2021/4/12", type: "Datasources", value: 1},
                   %{created_at: "2021/4/12", type: "Datasources", value: 1}
                 ],
                 state: :ready,
                 title: "Incidents by date",
                 updated_in_minutes: _
               } = data
      end
    end
  end
end
