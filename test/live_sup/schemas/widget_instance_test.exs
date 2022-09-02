defmodule LiveSup.Tests.Schemas.WidgetInstanceTest do
  use ExUnit.Case
  use LiveSup.DataCase

  alias LiveSup.Schemas.{WidgetInstance, Widget}

  setup do
    widget_instance = %WidgetInstance{
      settings: %{
        "widget_value" => %{
          "type" => "string",
          "source" => "local",
          "value" => 99_999
        },
        "key" => %{
          "type" => "string",
          "source" => "local",
          "value" => "hello"
        },
        "another_key" => %{
          "type" => "string",
          "source" => "local",
          "value" => "another key"
        },
        "and_another" => %{
          "type" => "string",
          "source" => "local",
          "value" => "another one"
        }
      },
      widget: %Widget{
        settings: %{
          "widget_value" => %{
            "type" => "string",
            "source" => "local",
            "value" => "1234"
          }
        }
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{
          "token" => %{
            "type" => "string",
            "source" => "local",
            "value" => "1234"
          },
          "secret_token" => %{
            "type" => "string",
            "source" => "env",
            "value" => "SUPER_SECRET_TOKEN"
          },
          "runs_every" => %{
            "type" => "int",
            "value" => "43200",
            "source" => "local"
          },
          "title" => %{
            "type" => "string",
            "value" => "Some custom title",
            "source" => "local"
          },
          "ids" => %{
            "type" => "array",
            "value" => "hola,chau",
            "source" => "local"
          },
          "ids_single" => %{
            "type" => "array",
            "value" => "hola",
            "source" => "local"
          }
        },
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{
            "audience" => %{
              "type" => "string",
              "value" => "super_secret",
              "source" => "local"
            }
          }
        }
      }
    }

    %{widget_instance: widget_instance}
  end

  @tag :widget_instance
  test "getting settings", %{widget_instance: widget_instance} do
    assert WidgetInstance.get_setting(widget_instance, "key") == "hello"

    assert WidgetInstance.get_setting(widget_instance, "token") == "1234"

    assert WidgetInstance.get_setting(widget_instance, "runs_every") == 43_200

    assert WidgetInstance.get_setting(widget_instance, "ids") == ["hola", "chau"]

    assert WidgetInstance.get_setting(widget_instance, "ids_single") == ["hola"]

    assert WidgetInstance.get_setting(widget_instance, "audience") == "super_secret"

    assert WidgetInstance.get_setting(widget_instance, "widget_value") == "99999"

    assert WidgetInstance.custom_title(widget_instance) == "Some custom title"

    System.put_env("SUPER_SECRET_TOKEN", "111")

    values =
      WidgetInstance.get_settings(widget_instance, ["key", "another_key", "token", "secret_token"])

    assert values == %{
             "key" => "hello",
             "another_key" => "another key",
             "token" => "1234",
             "secret_token" => "111"
           }
  end
end
