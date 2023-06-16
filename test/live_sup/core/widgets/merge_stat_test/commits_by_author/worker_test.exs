defmodule LiveSup.Test.Core.Widgets.MergeStat.CommitsByAuthor.WorkerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.{
    Worker,
    Handler
  }

  alias LiveSup.Core.Widgets.{WidgetData, WidgetManager, WorkerTaskSupervisor}
  alias LiveSup.Schemas.WidgetInstance

  describe "Wordpress direcotry sizes widget" do
    @describetag :widget
    @describetag :merge_stat_github_authors_widget

    @handler_error_response {:error, "could not execute query: near \"asdf\": syntax error"}

    @common_settings %{
      "limit" => %{
        "source" => "local",
        "type" => "string",
        "value" => 5,
        "required" => true
      },
      "repo" => %{
        "source" => "local",
        "type" => "string",
        "value" => "https://github.com/livebook-dev/livebook",
        "required" => true
      }
    }

    @widget_instance %WidgetInstance{
      id: "91b5e49d-5b5a-4894-be50-1c9299b6d70d",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Worker",
        settings: %{}
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
        worker_handler: "LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Worker",
        settings: %{}
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: @common_settings
        }
      }
    }

    setup do
      WidgetManager.stop_widgets()
      :ok
    end

    test "checking merge stat github authors widget server" do
      with_mock Handler, get_data: fn _args -> handler_response() end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: [
                   %{
                     "author_name" => "Jonatan Kłosko",
                     "count" => 341
                   },
                   %{
                     "author_name" => "jonatanklosko",
                     "count" => 123
                   },
                   %{
                     "author_name" => "José Valim",
                     "count" => 91
                   },
                   %{
                     "author_name" => "josevalim",
                     "count" => 10
                   },
                   %{
                     "author_name" => "Wojtek Mach",
                     "count" => 10
                   }
                 ],
                 state: :ready,
                 title: "Commits by Author",
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
                   error_description: "could not execute query: near \"asdf\": syntax error"
                 },
                 state: :error,
                 title: "Commits by Author",
                 updated_in_minutes: _
               } = data
      end
    end

    def handler_response() do
      {:ok,
       [
         %{
           "author_name" => "Jonatan Kłosko",
           "count" => 341
         },
         %{
           "author_name" => "jonatanklosko",
           "count" => 123
         },
         %{
           "author_name" => "José Valim",
           "count" => 91
         },
         %{
           "author_name" => "josevalim",
           "count" => 10
         },
         %{
           "author_name" => "Wojtek Mach",
           "count" => 10
         }
       ]}
    end
  end
end
