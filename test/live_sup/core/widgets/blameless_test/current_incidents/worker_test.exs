defmodule LiveSup.Test.Core.Widgets.Blameless.CurrentIncidents.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.Blameless.CurrentIncidents.{
    Worker,
    Handler
  }

  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetManager, WidgetData, WorkerTaskSupervisor}

  describe "Blameless current incidents widget" do
    @describetag :widget
    @describetag :blameless_current_incidents_widget

    @widget_instance %WidgetInstance{
      id: "e15638c7-c777-4531-997a-8f9ce971ff08",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Blameless.CurrentIncidents.Worker"
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{"client_id" => "xxx", "client_secret" => "xxx", "audience" => "xxx"},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{
            "client_id" => %{
              "type" => "env",
              "value" => "BLAMELESS_CLIENT_ID",
              "required" => true
            },
            "client_secret" => %{
              "type" => "env",
              "value" => "BLAMELESS_CLIENT_SECRET",
              "required" => true
            },
            "audience" => %{
              "type" => "env",
              "value" => "BLAMELESS_AUDIENCE",
              "required" => true
            }
          }
        }
      }
    }

    @handler_response {
      :ok,
      [
        %{
          commander: %{
            avatar_url: "https://avatars.slack-edge.com/2020-02-05/312300803504_32.jpg",
            email: "random@livesup.com",
            full_name: "Julius Random",
            title: "Network Engineer"
          },
          communication_lead: %{
            avatar_url: "https://avatars.slack-edge.com/2011-11-20/12323211510272_32.jpg",
            email: "hello@livesup.com",
            full_name: "Hello LiveSup",
            title: "Cloud Support Engineer"
          },
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
          description: "Blameless current incidents plugin is broken!",
          severity: "SEV2: Urgent Problem",
          slack: %{
            channel: "_incident-843",
            url: "https://livesup.slack.com/archives/C027R80T42E"
          },
          status: "RESOLVED",
          type: "Widgets",
          updated_at: ~U[2021-07-12 09:54:14.281Z],
          url: "https://livesup.blameless.io/incidents/843/events"
        }
      ]
    }

    setup do
      WidgetManager.stop_widgets()

      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      :ok
    end

    test "checking blameless current incidents server state" do
      with_mock Handler, get_data: fn _args -> @handler_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %WidgetData{
                 data: [
                   %{
                     commander: %{
                       avatar_url:
                         "https://avatars.slack-edge.com/2020-02-05/312300803504_32.jpg",
                       email: "random@livesup.com",
                       full_name: "Julius Random",
                       title: "Network Engineer"
                     },
                     communication_lead: %{
                       avatar_url:
                         "https://avatars.slack-edge.com/2011-11-20/12323211510272_32.jpg",
                       email: "hello@livesup.com",
                       full_name: "Hello LiveSup",
                       title: "Cloud Support Engineer"
                     },
                     created_at: ~U[2021-07-12 08:22:12.985Z],
                     created_at_ago: "3 months ago",
                     description: "Blameless current incidents plugin is broken!",
                     severity: "SEV2: Urgent Problem",
                     slack: %{
                       channel: "_incident-843",
                       url: "https://livesup.slack.com/archives/C027R80T42E"
                     },
                     status: "RESOLVED",
                     type: "Widgets",
                     updated_at: ~U[2021-07-12 09:54:14.281Z],
                     url: "https://livesup.blameless.io/incidents/843/events"
                   }
                 ],
                 state: :ready,
                 title: "Current incidents",
                 updated_in_minutes: _
               } = data
      end
    end
  end
end
