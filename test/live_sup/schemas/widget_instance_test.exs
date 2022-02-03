defmodule LiveSup.Tests.Schemas.WidgetInstanceTest do
  use ExUnit.Case
  use LiveSup.DataCase

  alias LiveSup.Schemas.WidgetInstance

  @default_keys %{
    "key" => "hello",
    "another_key" => "another key",
    "and_another" => "and another"
  }

  setup do
    widget_instance = %WidgetInstance{
      settings: @default_keys,
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

    assert WidgetInstance.get_setting(widget_instance, "runs_every") == 43200

    assert WidgetInstance.get_setting(widget_instance, "audience") == "super_secret"

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
