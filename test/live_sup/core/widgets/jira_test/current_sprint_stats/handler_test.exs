defmodule LiveSup.Test.Core.Widgets.Jira.CurrentSprintStats.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.Jira.CurrentSprintStats.Handler
  alias LiveSup.Core.Datasources.JiraDatasource
  alias LiveSup.Helpers.DateHelper

  describe "Managing Jira current sprint stats" do
    @describetag :widget
    @describetag :jira_current_sprint_stats_widget
    @describetag :jira_current_sprint_stats_widget_handler

    @project_statuses [
      %{id: "10576", name: "Published"},
      %{id: "10575", name: "Ready for Publish"},
      %{id: "10571", name: "Review"},
      %{id: "10539", name: "Done"},
      %{id: "10538", name: "In Progress"},
      %{id: "10537", name: "To Do"}
    ]

    test "getting the current sprint stats" do
      with_mocks([
        {JiraDatasource, [],
         [get_project_status: fn _project, _args -> {:ok, @project_statuses} end]},
        {JiraDatasource, [],
         [get_current_sprint_issues: fn _board, _args -> {:ok, jira_issues()} end]}
      ]) do
        data =
          %{
            "board_id" => 431,
            "project" => "123",
            "token" => "xxxx",
            "domain" => "https://livesup.awesome"
          }
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

    defp jira_issues() do
      [
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          author: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-14669",
          status: "Done",
          summary:
            "[API] Add bulk VLAN assign/unassign handlers to network_port and network_bond_port"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          author: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-14668",
          status: "Done",
          summary: "[API] Add bulk VLAN unassign endpoint"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          author: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15232",
          status: "Done",
          summary: "[API] Refactor network_port VLAN assignment to support bulk ops"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          author: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15233",
          status: "In Progress",
          summary: "[API] Refactor network_bond_port VLAN assignment to support bulk ops"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          author: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15234",
          status: "Done",
          summary: "[API] Refactor network_port VLAN unassignment to support bulk ops"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          author: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15235",
          status: "Done",
          summary: "[API] Refactor network_bond_port VLAN unassignment to support bulk ops"
        },
        %{
          assignee: nil,
          author: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15603",
          status: "Review",
          summary: "[API] Validate a VLAN only appears once in the batch"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5d6868ebe90c310c172268f3/13a96b53-de49-418d-91af-66ab290795a3/48",
            email: "crzysztof@livesup.com",
            full_name: "Chris Don"
          },
          author: %{
            avatar:
              "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
            email: "linda@livesup.com",
            full_name: "Linda Cookie"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15331",
          status: "Review",
          summary: "Fix top 10 slow tests in cucumber"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
            email: "jordanmonday@livesup.com",
            full_name: "Jordan Monday"
          },
          author: %{
            avatar:
              "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
            email: "linda@livesup.com",
            full_name: "Linda Cookie"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15291",
          status: "Done",
          summary: "Clean up old VLANs"
        },
        %{
          assignee: %{
            avatar:
              "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/48",
            email: "muh@livesup.com",
            full_name: "Muhamed Rocky"
          },
          author: %{
            avatar:
              "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/48",
            email: "muh@livesup.com",
            full_name: "Muhamed Rocky"
          },
          components: nil,
          created_at: Timex.now(),
          created_at_ago: DateHelper.from_now(),
          key: "ENG-15132",
          status: "Done",
          summary: "Swagger - fixing errors reported by Spectral linter "
        }
      ]
    end
  end
end
