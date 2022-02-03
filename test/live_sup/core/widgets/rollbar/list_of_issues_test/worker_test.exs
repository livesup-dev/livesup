defmodule LiveSup.Test.Core.Widgets.Rollbar.ListOfIssues.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.Rollbar.ListOfIssues.{
    Worker,
    Handler
  }

  alias LiveSup.Core.Widgets.{WidgetData, WidgetManager, WorkerTaskSupervisor}
  alias LiveSup.Schemas.WidgetInstance

  describe "Rollbar.ListOfIssues widget" do
    @describetag :widget
    @describetag :rollbar_list_of_issues_widget

    @handler_error_response {:error, "invalid access token"}

    @common_settings %{
      "limit" => %{
        "source" => "local",
        "type" => "string",
        "value" => 5,
        "required" => true
      },
      "env" => %{
        "source" => "local",
        "type" => "string",
        "value" => "production",
        "required" => true
      },
      "status" => %{
        "source" => "local",
        "type" => "string",
        "value" => "active",
        "required" => true
      },
      "token" => %{
        "source" => "local",
        "type" => "string",
        "value" => "xxxxx",
        "required" => true
      }
    }

    @widget_instance %WidgetInstance{
      id: "bcb7e1ed-9d8d-4726-a35a-df46b78c0007",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Rollbar.ListOfIssues.Worker"
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: @common_settings
        }
      }
    }

    @widget_instance_with_error %WidgetInstance{
      id: "e0c1f3bc-e72c-4fac-9bff-95dcd7362bbc",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Rollbar.ListOfIssues.Worker"
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: @common_settings
        }
      }
    }

    setup do
      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      :ok
    end

    test "checking rollbar list of issues widget server" do
      with_mock Handler, get_data: fn _args -> handler_response() end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: [
                   %{
                     counter: 3,
                     last_occurrence: ~U[2021-11-18 22:14:33Z],
                     last_occurrence_ago: _,
                     short_title: "UndefinedFunctionError...",
                     title:
                       "UndefinedFunctionError: function Noooooooooooooo.noooooo/0 is undefined (module Noooooooooooooo is not available)",
                     total_occurrences: 1,
                     url: "https://rollbar.com/[TBD]/items/3/"
                   },
                   %{
                     counter: 2,
                     last_occurrence: ~U[2021-11-18 22:14:03Z],
                     last_occurrence_ago: _,
                     short_title: "UndefinedFunctionError...",
                     title:
                       "UndefinedFunctionError: function Whaaaaat.really/0 is undefined (module Whaaaaat is not available)",
                     total_occurrences: 1,
                     url: "https://rollbar.com/[TBD]/items/2/"
                   },
                   %{
                     counter: 1,
                     last_occurrence: ~U[2021-11-18 22:05:27Z],
                     last_occurrence_ago: _,
                     short_title: "UndefinedFunctionError...",
                     title:
                       "UndefinedFunctionError: function DoesNotExist.for_sure/0 is undefined (module DoesNotExist is not available)",
                     total_occurrences: 2,
                     url: "https://rollbar.com/[TBD]/items/1/"
                   }
                 ],
                 state: :ready,
                 title: "Rollbar issues",
                 updated_in_minutes: _
               } = data
      end
    end

    test "checking weather widget state with error" do
      with_mock Handler, get_data: fn _args -> @handler_error_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance_with_error)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance_with_error)

        assert %WidgetData{
                 data: %{
                   error_description: "invalid access token"
                 },
                 state: :error,
                 title: "Rollbar issues",
                 updated_in_minutes: _
               } = data
      end
    end

    def handler_response() do
      {:ok,
       [
         %{
           counter: 3,
           last_occurrence: ~U[2021-11-18 22:14:33Z],
           last_occurrence_ago: "2 mins ago",
           short_title: "UndefinedFunctionError...",
           title:
             "UndefinedFunctionError: function Noooooooooooooo.noooooo/0 is undefined (module Noooooooooooooo is not available)",
           total_occurrences: 1,
           url: "https://rollbar.com/[TBD]/items/3/"
         },
         %{
           counter: 2,
           last_occurrence: ~U[2021-11-18 22:14:03Z],
           last_occurrence_ago: "2 mins ago",
           short_title: "UndefinedFunctionError...",
           title:
             "UndefinedFunctionError: function Whaaaaat.really/0 is undefined (module Whaaaaat is not available)",
           total_occurrences: 1,
           url: "https://rollbar.com/[TBD]/items/2/"
         },
         %{
           counter: 1,
           last_occurrence: ~U[2021-11-18 22:05:27Z],
           last_occurrence_ago: "2 mins ago",
           short_title: "UndefinedFunctionError...",
           title:
             "UndefinedFunctionError: function DoesNotExist.for_sure/0 is undefined (module DoesNotExist is not available)",
           total_occurrences: 2,
           url: "https://rollbar.com/[TBD]/items/1/"
         }
       ]}
    end
  end
end
