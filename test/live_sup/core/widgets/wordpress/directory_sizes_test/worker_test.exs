defmodule LiveSup.Test.Core.Widgets.Wordpress.DirectorySizes.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.Wordpress.DirectorySizes.{
    Worker,
    Handler
  }

  alias LiveSup.Core.Widgets.Wordpress.WordpressConfig
  alias LiveSup.Core.Widgets.{WidgetManager, WidgetData, WorkerTaskSupervisor}
  alias LiveSup.Schemas.WidgetInstance

  describe "Wordpress direcotry sizes widget" do
    @describetag :widget
    @describetag :wordpress_directory_sizes_widget

    @handler_error_response {:error, "401: Sorry, you are not allowed to do that."}

    @common_settings %{
      "user" => %{
        "type" => "string",
        "source" => "local",
        "value" => "user",
        "required" => true
      },
      "application_password" => %{
        "type" => "string",
        "source" => "env",
        "value" => "WORDPRESS_TEST_APP_PASSWORD",
        "required" => true
      },
      "url" => %{
        "type" => "string",
        "source" => "local",
        "value" => "https://test.com",
        "required" => true
      }
    }

    @widget_instance %WidgetInstance{
      id: "17973dd8-0945-4fd2-874c-d94eb6adc8aa",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Wordpress.DirectorySizes.Worker",
        settings: %{}
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: @common_settings
        }
      }
    }

    @widget_instance_with_errror %WidgetInstance{
      id: "e0c1f3bc-e72c-4fac-9bff-95dcd7362bbc",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Wordpress.DirectorySizes.Worker",
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
      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      WidgetManager.stop_widgets()

      :ok
    end

    test "checking weather widget server" do
      with_mock Handler, get_data: fn %WordpressConfig{} = _config -> handler_response() end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: [
                   %{
                     "database_size" => %{
                       "debug" => "21.78 MB (22839296 bytes)",
                       "raw" => 22_839_296,
                       "size" => "21.78 MB"
                     },
                     "plugins_size" => %{
                       "debug" => "86.00 MB (90176646 bytes)",
                       "raw" => 90_176_646,
                       "size" => "86.00 MB"
                     },
                     "themes_size" => %{
                       "debug" => "25.53 MB (26774299 bytes)",
                       "raw" => 26_774_299,
                       "size" => "25.53 MB"
                     },
                     "total_size" => %{
                       "debug" => "715.89 MB (750669086 bytes)",
                       "raw" => 750_669_086,
                       "size" => "715.89 MB"
                     },
                     "uploads_size" => %{
                       "debug" => "532.32 MB (558177513 bytes)",
                       "raw" => 558_177_513,
                       "size" => "532.32 MB"
                     },
                     "wordpress_size" => %{
                       "debug" => "50.26 MB (52701332 bytes)",
                       "raw" => 52_701_332,
                       "size" => "50.26 MB"
                     }
                   }
                 ],
                 state: :ready,
                 title: "Wordpress directory sizes",
                 updated_in_minutes: _
               } = data
      end
    end

    test "checking weather widget state with error" do
      with_mock Handler, get_data: fn %WordpressConfig{} = _config -> @handler_error_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance_with_errror)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance_with_errror)

        assert %WidgetData{
                 data: %{error_description: "401: Sorry, you are not allowed to do that."},
                 state: :error,
                 title: "Wordpress directory sizes",
                 updated_in_minutes: _
               } = data
      end
    end

    def handler_response() do
      {:ok,
       [
         %{
           "database_size" => %{
             "debug" => "21.78 MB (22839296 bytes)",
             "raw" => 22_839_296,
             "size" => "21.78 MB"
           },
           "plugins_size" => %{
             "debug" => "86.00 MB (90176646 bytes)",
             "raw" => 90_176_646,
             "size" => "86.00 MB"
           },
           "raw" => 0,
           "themes_size" => %{
             "debug" => "25.53 MB (26774299 bytes)",
             "raw" => 26_774_299,
             "size" => "25.53 MB"
           },
           "total_size" => %{
             "debug" => "715.89 MB (750669086 bytes)",
             "raw" => 750_669_086,
             "size" => "715.89 MB"
           },
           "uploads_size" => %{
             "debug" => "532.32 MB (558177513 bytes)",
             "raw" => 558_177_513,
             "size" => "532.32 MB"
           },
           "wordpress_size" => %{
             "debug" => "50.26 MB (52701332 bytes)",
             "raw" => 52_701_332,
             "size" => "50.26 MB"
           }
         }
       ]}
    end
  end
end
