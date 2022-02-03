defmodule LiveSup.Test.Core.Widgets.Jira.CurrentSprint.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.Jira.CurrentSprint.Handler
  alias LiveSup.Core.Datasources.JiraDatasource

  describe "Managing Jira current Sprint" do
    @describetag :widget
    @describetag :jira_current_sprint_widget
    @describetag :jira_current_sprint_widget_handler

    @current_sprint %{
      days_left: -139,
      endDate: "2021-06-01T17:38:00.000Z",
      goal: "Some cool goal description.",
      id: 431,
      name: "Livesup Sprint 10-21",
      startDate: "2021-05-18T14:45:51.832Z",
      state: "active"
    }

    test "getting the current sprint" do
      with_mock JiraDatasource,
        get_current_sprint: fn _board_id, _token -> {:ok, @current_sprint} end do
        data =
          %{"board_id" => 431, "token" => "xxxx", "domain" => "https://livesup.awesome"}
          |> Handler.get_data()

        assert {
                 :ok,
                 %{
                   days_left: -139,
                   endDate: "2021-06-01T17:38:00.000Z",
                   goal: "Some cool goal description.",
                   id: 431,
                   name: "Livesup Sprint 10-21",
                   startDate: "2021-05-18T14:45:51.832Z",
                   state: "active"
                 }
               } = data
      end
    end
  end
end
