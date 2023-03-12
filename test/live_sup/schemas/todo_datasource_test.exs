defmodule LiveSup.Tests.Schemas.TodoDatasourceTest do
  use ExUnit.Case
  use LiveSup.DataCase

  alias LiveSup.Schemas.TodoDatasource

  setup do
    todo_datasource = %TodoDatasource{
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

    %{todo_datasource: todo_datasource}
  end

  @tag :todo_datasource
  test "getting settings", %{todo_datasource: todo_datasource} do
    assert TodoDatasource.get_setting(todo_datasource, "key") == "hello"

    assert TodoDatasource.get_setting(todo_datasource, "token") == "1234"

    assert TodoDatasource.get_setting(todo_datasource, "runs_every") == 43_200

    assert TodoDatasource.get_setting(todo_datasource, "ids") == ["hola", "chau"]

    assert TodoDatasource.get_setting(todo_datasource, "ids_single") == ["hola"]

    assert TodoDatasource.get_setting(todo_datasource, "audience") == "super_secret"

    assert TodoDatasource.get_setting(todo_datasource, "widget_value") == "99999"

    System.put_env("SUPER_SECRET_TOKEN", "111")

    values =
      TodoDatasource.get_settings(todo_datasource, ["key", "another_key", "token", "secret_token"])

    assert values == %{
             "key" => "hello",
             "another_key" => "another key",
             "token" => "1234",
             "secret_token" => "111"
           }
  end
end
