defmodule LiveSup.Test.Core.Widgets.Rollbar.ListOfIssues.HandlerTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Widgets.Rollbar.ListOfIssues.Handler

  describe "Managing Rollbar.ListOfIssues handler" do
    @describetag :widget
    @describetag :rollbar_list_of_issues_widget
    @describetag :rollbar_list_of_issues_handler

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    @tag :rollbar_list_of_issues
    test "getting list of errors", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/items", fn conn ->
        Plug.Conn.resp(conn, 200, response())
      end)

      data =
        Handler.get_data(
          %{"env" => "production", "limit" => 3, "status" => "active", "token" => "xxx", "item_prefix" => "livesup"},
          url: endpoint_url(bypass.port)
        )

      assert {:ok,
              [
                %{
                  counter: 3,
                  last_occurrence: ~U[2021-11-18 22:14:33Z],
                  last_occurrence_ago: _,
                  short_title: "UndefinedFunctionError: function Nooooooooooooo...",
                  title:
                    "UndefinedFunctionError: function Noooooooooooooo.noooooo/0 is undefined (module Noooooooooooooo is not available)",
                  total_occurrences: 1,
                  url: "https://rollbar.com/livesup/items/3/"
                },
                %{
                  counter: 2,
                  last_occurrence: ~U[2021-11-18 22:14:03Z],
                  last_occurrence_ago: _,
                  short_title: "UndefinedFunctionError: function Whaaaaat.reall...",
                  title:
                    "UndefinedFunctionError: function Whaaaaat.really/0 is undefined (module Whaaaaat is not available)",
                  total_occurrences: 1,
                  url: "https://rollbar.com/livesup/items/2/"
                },
                %{
                  counter: 1,
                  last_occurrence: ~U[2021-11-18 22:05:27Z],
                  last_occurrence_ago: _,
                  short_title: "UndefinedFunctionError: function DoesNotExist.f...",
                  title:
                    "UndefinedFunctionError: function DoesNotExist.for_sure/0 is undefined (module DoesNotExist is not available)",
                  total_occurrences: 2,
                  url: "https://rollbar.com/livesup/items/1/"
                }
              ]} = data
    end

    test "failing getting the list of authors", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/items", fn conn ->
        Plug.Conn.resp(conn, 403, error_response())
      end)

      data =
        Handler.get_data(
          %{"env" => "production", "limit" => 3, "status" => "active", "token" => "xxx"},
          url: endpoint_url(bypass.port)
        )

      assert {:error, "invalid access token"} = data
    end
  end

  def response() do
    """
    {
      "err": 0,
      "result": {
          "items": [
              {
                  "public_item_id": null,
                  "integrations_data": null,
                  "level_lock": 0,
                  "controlling_id": 1152746872,
                  "last_activated_timestamp": 1637273673,
                  "assigned_user_id": null,
                  "group_status": 1,
                  "hash": "3d4e473e2470092b00726dc168e219579998ebd2",
                  "id": 1152746872,
                  "environment": "production",
                  "title_lock": 0,
                  "title": "UndefinedFunctionError: function Noooooooooooooo.noooooo/0 is undefined (module Noooooooooooooo is not available)",
                  "last_occurrence_id": 200137760519,
                  "last_occurrence_timestamp": 1637273673,
                  "platform": "unknown",
                  "first_occurrence_timestamp": 1637273673,
                  "project_id": 529489,
                  "resolved_in_version": null,
                  "status": "active",
                  "unique_occurrences": null,
                  "group_item_id": null,
                  "framework": "unknown",
                  "total_occurrences": 1,
                  "level": "error",
                  "counter": 3,
                  "last_modified_by": 272205,
                  "first_occurrence_id": 200137760519,
                  "activating_occurrence_id": 200137760519,
                  "last_resolved_timestamp": null
              },
              {
                  "public_item_id": null,
                  "integrations_data": null,
                  "level_lock": 0,
                  "controlling_id": 1152746668,
                  "last_activated_timestamp": 1637273643,
                  "assigned_user_id": null,
                  "group_status": 1,
                  "hash": "0b426cf12baea5110a4f9fe886b6cb6ae908151c",
                  "id": 1152746668,
                  "environment": "production",
                  "title_lock": 0,
                  "title": "UndefinedFunctionError: function Whaaaaat.really/0 is undefined (module Whaaaaat is not available)",
                  "last_occurrence_id": 200137656353,
                  "last_occurrence_timestamp": 1637273643,
                  "platform": "unknown",
                  "first_occurrence_timestamp": 1637273643,
                  "project_id": 529489,
                  "resolved_in_version": null,
                  "status": "active",
                  "unique_occurrences": null,
                  "group_item_id": null,
                  "framework": "unknown",
                  "total_occurrences": 1,
                  "level": "error",
                  "counter": 2,
                  "last_modified_by": 272205,
                  "first_occurrence_id": 200137656353,
                  "activating_occurrence_id": 200137656353,
                  "last_resolved_timestamp": null
              },
              {
                  "public_item_id": null,
                  "integrations_data": null,
                  "level_lock": 0,
                  "controlling_id": 1152743832,
                  "last_activated_timestamp": 1637273063,
                  "assigned_user_id": null,
                  "group_status": 1,
                  "hash": "4afb20c256f99517c16c18db84e3c832859cbc6c",
                  "id": 1152743832,
                  "environment": "production",
                  "title_lock": 0,
                  "title": "UndefinedFunctionError: function DoesNotExist.for_sure/0 is undefined (module DoesNotExist is not available)",
                  "last_occurrence_id": 200136222320,
                  "last_occurrence_timestamp": 1637273127,
                  "platform": "unknown",
                  "first_occurrence_timestamp": 1637273063,
                  "project_id": 529489,
                  "resolved_in_version": null,
                  "status": "active",
                  "unique_occurrences": null,
                  "group_item_id": null,
                  "framework": "unknown",
                  "total_occurrences": 2,
                  "level": "error",
                  "counter": 1,
                  "last_modified_by": 236365,
                  "first_occurrence_id": 200136020706,
                  "activating_occurrence_id": 200136020706,
                  "last_resolved_timestamp": null
              }
          ],
          "page": 1,
          "total_count": 3
      }
    }
    """
  end

  def error_response() do
    """
    {
      "err": 1,
      "message": "invalid access token"
    }
    """
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
