defmodule LiveSup.Test.Core.Widgets.Jira.ListOfEpics.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.Jira.ListOfEpics.Handler
  alias LiveSup.Core.Widgets.WidgetContext
  alias LiveSup.Core.Datasources.JiraDatasource
  alias LiveSup.Test.AccountsFixtures
  alias LiveSup.Schemas.WidgetInstance

  describe "Managing Jira list of epics" do
    @describetag :widget
    @describetag :jira_list_of_epics_widget
    @describetag :jira_list_of_epics_widget_handler

    test "getting the list of epics" do
      with_mock JiraDatasource,
        epic_issues: fn _project, _component, _args -> {:ok, jira_issues()} end do
        data =
          %{
            "token" => "xxxx",
            "domain" => "https://livesup.awesome",
            "project" => "ENG",
            "component" => "Network"
          }
          |> Handler.get_data()

        ok_result = ok_result()

        assert ok_result == data
      end
    end

    def ok_result() do
      {
        :ok,
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
      }
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
