defmodule LiveSup.Test.Core.Datasources.PagerDutyDatasourceTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Datasources.PagerDutyDatasource

  describe "PagerDuty datasource" do
    @describetag :pager_duty_datasource
    @describetag :datasource

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    @tag :pager_duty_on_call
    test "Get on call", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/oncalls",
        fn conn ->
          Plug.Conn.resp(conn, 200, on_call_response())
        end
      )

      {:ok, data} =
        PagerDutyDatasource.get_on_call(
          %{"schedule_ids" => ["PI50L4I"], "token" => "xxxx"},
          url: endpoint_url(bypass.port)
        )

      assert [
               %{
                 end: "2022-04-18T09:00:00Z",
                 days_left: _,
                 id: nil,
                 name: %{
                   "html_url" => "https://livesup.pagerduty.com/schedules/PLBW9ZW",
                   "id" => "PLBW9ZW",
                   "self" => "https://api.pagerduty.com/schedules/PLBW9ZW",
                   "summary" => "Central Team",
                   "type" => "schedule_reference"
                 },
                 start: _,
                 user: %{id: "P6S8MID", name: "James First"}
               },
               %{
                 end: "2022-04-25T09:00:00Z",
                 days_left: _,
                 id: nil,
                 name: %{
                   "html_url" => "https://livesup.pagerduty.com/schedules/PLBW9ZW",
                   "id" => "PLBW9ZW",
                   "self" => "https://api.pagerduty.com/schedules/PLBW9ZW",
                   "summary" => "Central Team",
                   "type" => "schedule_reference"
                 },
                 start: _,
                 user: %{id: "P6S8MID", name: "Peter Second"}
               }
             ] = data
    end

    defp endpoint_url(port), do: "http://localhost:#{port}"

    defp on_call_response() do
      """
      {
        "oncalls": [
          {
            "escalation_policy": {
              "id": "PI50L4I",
              "type": "escalation_policy_reference",
              "summary": "Central Team",
              "self": "https://api.pagerduty.com/escalation_policies/PI50L4I",
              "html_url": "https://livesup.pagerduty.com/escalation_policies/PI50L4I"
            },
            "escalation_level": 1,
            "schedule": {
              "id": "PLBW9ZW",
              "type": "schedule_reference",
              "summary": "Central Team",
              "self": "https://api.pagerduty.com/schedules/PLBW9ZW",
              "html_url": "https://livesup.pagerduty.com/schedules/PLBW9ZW"
            },
            "user": {
              "id": "P6S8MID",
              "type": "user_reference",
              "summary": "Peter Second",
              "self": "https://api.pagerduty.com/users/P6S8MID",
              "html_url": "https://livesup.pagerduty.com/users/P6S8MID"
            },
            "start": "2022-04-18T09:00:00Z",
            "end": "2022-04-25T09:00:00Z",
            "days_left": 7
          },
          {
            "escalation_policy": {
              "id": "PI50L4I",
              "type": "escalation_policy_reference",
              "summary": "Central Team",
              "self": "https://api.pagerduty.com/escalation_policies/PI50L4I",
              "html_url": "https://livesup.pagerduty.com/escalation_policies/PI50L4I"
            },
            "escalation_level": 1,
            "schedule": {
              "id": "PLBW9ZW",
              "type": "schedule_reference",
              "summary": "Central Team",
              "self": "https://api.pagerduty.com/schedules/PLBW9ZW",
              "html_url": "https://livesup.pagerduty.com/schedules/PLBW9ZW"
            },
            "user": {
              "id": "P6S8MID",
              "type": "user_reference",
              "summary": "James First",
              "self": "https://api.pagerduty.com/users/P6S8MID",
              "html_url": "https://livesup.pagerduty.com/users/P6S8MID"
            },
            "start": "2022-04-11T09:00:00Z",
            "end": "2022-04-18T09:00:00Z",
            "days_left": 7
          },
          {
            "escalation_policy": {
              "id": "PI50L4I",
              "type": "escalation_policy_reference",
              "summary": "Central Team",
              "self": "https://api.pagerduty.com/escalation_policies/PI50L4I",
              "html_url": "https://livesup.pagerduty.com/escalation_policies/PI50L4I"
            },
            "escalation_level": 1,
            "schedule": {
              "id": "PLBW9ZW",
              "type": "schedule_reference",
              "summary": "Central Team",
              "self": "https://api.pagerduty.com/schedules/PLBW9ZW",
              "html_url": "https://livesup.pagerduty.com/schedules/PLBW9ZW"
            },
            "user": {
              "id": "P6S8MID",
              "type": "user_reference",
              "summary": "John Third",
              "self": "https://api.pagerduty.com/users/P6S8MID",
              "html_url": "https://livesup.pagerduty.com/users/P6S8MID"
            },
            "start": "2022-04-25T09:00:00Z",
            "end": "2022-05-02T09:00:00Z",
            "days_left": 7
          }
        ],
        "limit": 25,
        "offset": 0,
        "more": false,
        "total": null
      }
      """
    end
  end
end
