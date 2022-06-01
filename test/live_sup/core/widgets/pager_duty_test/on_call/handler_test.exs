defmodule LiveSup.Test.Core.Widgets.PagerDuty.OnCall.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.PagerDuty.OnCall.Handler
  alias LiveSup.Core.Datasources.PagerDutyDatasource

  describe "Managing PagerDuty on call" do
    @describetag :widget
    @describetag :pager_duty_on_call_widget
    @describetag :pager_duty_on_call_widget_handler

    @on_call [
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

    test "getting who is on call" do
      with_mock PagerDutyDatasource,
        get_on_call: fn %{"schedule_ids" => _schedule_ids, "token" => _token} ->
          {:ok, @on_call}
        end do
        data =
          %{"schedule_ids" => ["1234"], "token" => "xxxx"}
          |> Handler.get_data()

        assert {
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
               } = data
      end
    end
  end
end
