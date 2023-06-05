defmodule LiveSup.Test.Core.Widgets.PagerDuty.OnCall.WorkerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.PagerDuty.OnCall.{Worker, Handler}
  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetManager, WidgetData, WorkerTaskSupervisor}

  describe "PagerDuty OnCall widget" do
    @describetag :widget
    @describetag :pager_duty_on_call_widget
    @describetag :pager_duty_on_call_widget_worker

    @handler_response {
      :ok,
      [
        %{
          id: "PI50L4A",
          name: "Central Team",
          user: %{
            id: "P6S8MID",
            name: "James Doe"
          },
          start: "2022-04-11T09:00:00Z",
          end: "2022-04-18T09:00:00Z",
          days_left: 7
        }
      ]
    }

    @widget_instance %WidgetInstance{
      id: "f7933b41-7590-4622-af8a-b31660b55544",
      settings: %{"token" => "xxxxx", "schedule_ids" => ["1234"]},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.PagerDuty.OnCall.Worker",
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
      WidgetManager.stop_widgets()

      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      # Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      :ok
    end

    test "checking PagerDuty OnCall worker" do
      with_mock Handler, get_data: fn _arg -> @handler_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %WidgetData{
                 data: [
                   %{
                     id: "PI50L4A",
                     name: "Central Team",
                     user: %{
                       id: "P6S8MID",
                       name: "James Doe"
                     },
                     start: "2022-04-11T09:00:00Z",
                     end: "2022-04-18T09:00:00Z",
                     days_left: 7
                   }
                 ],
                 state: :ready,
                 title: "On Call",
                 updated_in_minutes: _
               } = data
      end
    end
  end
end
