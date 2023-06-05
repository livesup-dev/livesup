defmodule LiveSup.Test.Core.Widgets.Jira.ListOfIssues.WorkerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.Jira.ListOfIssues.Worker
  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetManager, WidgetData, WorkerTaskSupervisor}
  alias LiveSup.Core.Datasources.JiraDatasource

  describe "Jira list of issues" do
    @describetag :widget
    @describetag :jira_list_of_issues_widget
    @describetag :jira_list_of_issues_widget_worker

    @widget_instance %WidgetInstance{
      id: "e36d593e-f5a0-47bd-b6e8-c2fec3af3fbc",
      name: "List of issues",
      settings: %{
        "statuses" => %{
          "source" => "local",
          "type" => "array",
          "value" => "Open,In Progress,In Review"
        },
        "token" => %{"source" => "local", "type" => "string", "value" => "xxxx"},
        "domain" => %{"source" => "local", "type" => "string", "value" => "https://something.com"}
      },
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Jira.ListOfIssues.Worker",
        settings: %{},
        global: false
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        id: "76e8e7f8-9a58-40c5-b549-a93aced248e8",
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    setup do
      WidgetManager.stop_widgets()

      user = LiveSup.Test.AccountsFixtures.user_fixture()
      %{user: user}
    end

    test "get list of issues", %{user: user} do
      with_mock JiraDatasource,
        search_tickets: fn _query, _args -> {:ok, jira_issues()} end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance, user)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance, user)

        assert %WidgetData{
                 data: %{error_description: :no_link_found},
                 icon: nil,
                 icon_svg: nil,
                 id: "e36d593e-f5a0-47bd-b6e8-c2fec3af3fbc",
                 public_settings: %{},
                 state: :error,
                 title: "Your Jira issues",
                 ui_settings: %{"size" => 1},
                 updated_in_minutes: _
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-06-12 08:22:12.985Z],
          created_at_ago: "2 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
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
          created_at: ~U[2021-07-12 08:22:12.985Z],
          created_at_ago: "3 months ago",
          key: "ENG-15132",
          status: "Done",
          summary: "Swagger - fixing errors reported by Spectral linter "
        }
      ]
    end
  end
end
