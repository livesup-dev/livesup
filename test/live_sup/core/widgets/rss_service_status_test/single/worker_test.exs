defmodule LiveSup.Test.Core.Widgets.RssServiceStatus.Single.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.RssServiceStatus.Single.{Worker, Handler}
  alias LiveSup.Core.Widgets.{WidgetManager, WidgetData, WorkerTaskSupervisor}
  alias LiveSup.Schemas.WidgetInstance

  describe "Rss Service Status widget" do
    @describetag :widget
    @describetag :rss_service_status_single_widget

    @handler_error_response {:error, "Can't read the API"}

    @handler_response {
      :ok,
      %{
        created_at: ~U[2021-10-13 11:34:34Z],
        created_at_ago: "4 days ago",
        status: :up,
        title: "Incident with GitHub Actions",
        url: "https://www.githubstatus.com/incidents/81lpnf07bm1q"
      }
    }

    @widget_instance %WidgetInstance{
      id: "955ef326-ab34-4163-afa3-d2a30aff0d0c",
      settings: %{"url" => "https://www.githubstatus.com/history.rss"},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.RssServiceStatus.Single.Worker",
        settings: %{}
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{
            "url" => %{
              "type" => "string",
              "source" => "local",
              "value" => "https://testing.com"
            },
            "icon" => %{
              "type" => "string",
              "source" => "local",
              "value" => "https://testing.com/icon.png"
            }
          }
        }
      }
    }

    @widget_instance_with_errror %WidgetInstance{
      id: "ede1976a-69e5-43f1-8250-697f3ef66129",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.RssServiceStatus.Single.Worker",
        settings: %{}
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{
            "url" => %{
              "type" => "string",
              "source" => "local",
              "value" => "https://testing.com"
            },
            "icon" => %{
              "type" => "string",
              "source" => "local",
              "value" => "https://testing.com/icon.png"
            }
          }
        }
      }
    }

    setup do
      WidgetManager.stop_widgets()

      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      :ok
    end

    test "checking rss service status widget server" do
      with_mock Handler, get_data: fn _args -> @handler_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: %{
                   created_at: ~U[2021-10-13 11:34:34Z],
                   created_at_ago: "4 days ago",
                   status: :up,
                   title: "Incident with GitHub Actions",
                   url: "https://www.githubstatus.com/incidents/81lpnf07bm1q"
                 },
                 state: :ready,
                 title: "Rss Service Status",
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
                 title: "Rss Service Status",
                 updated_in_minutes: _
               } = data
      end
    end
  end
end
