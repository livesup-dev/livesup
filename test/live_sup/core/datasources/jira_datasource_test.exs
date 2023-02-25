defmodule LiveSup.Test.Core.Datasources.JiraDatasourceTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Datasources.JiraDatasource

  alias LiveSup.Test.Core.Datasources.DataHelper.{
    JiraCurrentSprintIssues,
    JiraProjectStatuses
  }

  @no_sprint_response """
    {
      "maxResults": 50,
      "startAt": 0,
      "isLast": true,
      "values": []
    }
  """

  @response """
    {
      "maxResults": 50,
      "startAt": 0,
      "isLast": true,
      "values": [
          {
              "id": 431,
              "self": "https://livesup.atlassian.net/rest/agile/1.0/sprint/431",
              "state": "active",
              "name": "Livesup Sprint 10-21",
              "startDate": "2021-05-18T14:45:51.832Z",
              "endDate": "2021-06-01T17:38:00.000Z",
              "originBoardId": 145,
              "goal": "Some cool goal description."
          }
      ]
    }
  """

  @xml_error_response """
  <?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><status><status-code>401</status-code><message>Client must be authenticated to access this resource.</message></status>
  """

  describe "jira datasource" do
    @describetag :jira_datasource
    @describetag :datasource

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    @tag :jira_current_sprint
    test "Get current sprint", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/agile/1.0/board/145/sprint",
        fn conn ->
          Plug.Conn.resp(conn, 200, @response)
        end
      )

      {:ok, data} =
        JiraDatasource.get_current_sprint(
          "145",
          token: "xxxx",
          domain: endpoint_url(bypass.port)
        )

      assert %{
               days_left: _,
               endDate: "2021-06-01T17:38:00.000Z",
               goal: "Some cool goal description.",
               id: 431,
               name: "Livesup Sprint 10-21",
               startDate: "2021-05-18T14:45:51.832Z",
               state: "active"
             } = data
    end

    @tag :jira_current_sprint_with_no_active_sprint
    test "Get current sprint when no active one", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/agile/1.0/board/145/sprint",
        fn conn ->
          Plug.Conn.resp(conn, 200, @no_sprint_response)
        end
      )

      assert {:error, :no_active_sprint} =
               JiraDatasource.get_current_sprint(
                 "145",
                 token: "xxxx",
                 domain: endpoint_url(bypass.port)
               )
    end

    @tag datasource: true, jira_datasource: true
    test "Failing getting the current sprint", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/agile/1.0/board/145/sprint",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/xml;charset=UTF-8")
          |> Plug.Conn.resp(401, @xml_error_response)
        end
      )

      data =
        JiraDatasource.get_current_sprint(
          "145",
          token: "xxxxx",
          domain: endpoint_url(bypass.port)
        )

      assert {:error,
              "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><status><status-code>401</status-code><message>Client must be authenticated to access this resource.</message></status>\n"} =
               data
    end

    @tag :jira_projects_statuses
    test "Get project statuses", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/api/3/project/145/statuses",
        fn conn ->
          Plug.Conn.resp(conn, 200, statuses_response())
        end
      )

      {:ok, data} =
        JiraDatasource.get_project_status(
          "145",
          token: "xxxx",
          domain: endpoint_url(bypass.port)
        )

      assert [
               %{id: "10576", name: "Published"},
               %{id: "10575", name: "Ready for Publish"},
               %{id: "10571", name: "Review"},
               %{id: "10539", name: "Done"},
               %{id: "10538", name: "In Progress"},
               %{id: "10537", name: "To Do"}
             ] = data
    end

    @tag :jira_search_tickets
    test "Search tickets", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "POST",
        "/rest/api/3/search",
        fn conn ->
          Plug.Conn.resp(
            conn,
            200,
            LiveSup.Test.Core.Datasources.DataHelper.JiraListOfIssues.get()
          )
        end
      )

      {:ok, data} =
        JiraDatasource.search_tickets(
          "assignee = 123 AND (status = 'Open' OR status = 'In Progress' OR status = 'In Review') OR (updated > -3d AND assignee = 123)",
          token: "xxxx",
          domain: endpoint_url(bypass.port)
        )

      assert [
               %{
                 assignee: %{
                   avatar:
                     "https://livesup.prod.public.atl-paas.net/5a390ef9280a8d389404ee22s/53550071-f045-44f3-bc75-96956f8541c3/48",
                   email: "emiliano@livesup.com",
                   full_name: "Emiliano Jankowski"
                 },
                 author: %{
                   avatar:
                     "https://livesup.prod.public.atl-paas.net/5a390ef9280a8d389404ee22s/53550071-f045-44f3-bc75-96956f8541c3/48",
                   full_name: "Emiliano Jankowski"
                 },
                 components: nil,
                 created_at: _,
                 created_at_ago: _,
                 key: "SWE-0922",
                 status: "Complete",
                 summary: "Complete site Readme"
               },
               %{
                 assignee: %{
                   avatar:
                     "https://livesup.prod.public.atl-paas.net/5a390ef9280a8d389404ee22s/53550071-f045-44f3-bc75-96956f8541c3/48",
                   email: "emiliano@livesup.com",
                   full_name: "Emiliano Jankowski"
                 },
                 author: %{
                   avatar:
                     "https://livesup.prod.public.atl-paas.net/5a390ef9280a8d389404ee22s/53550071-f045-44f3-bc75-96956f8541c3/48",
                   full_name: "Emiliano Jankowski"
                 },
                 components: nil,
                 created_at: _,
                 created_at_ago: _,
                 key: "SWE-0926",
                 status: "Complete",
                 summary: "Complete site Readme"
               },
               %{
                 assignee: %{
                   avatar:
                     "https://livesup.prod.public.atl-paas.net/5a390ef9280a8d389404ee22s/53550071-f045-44f3-bc75-96956f8541c3/48",
                   email: "emiliano@livesup.com",
                   full_name: "Emiliano Jankowski"
                 },
                 author: %{
                   avatar:
                     "https://livesup.prod.public.atl-paas.net/5a390ef9280a8d389404ee22s/53550071-f045-44f3-bc75-96956f8541c3/48",
                   full_name: "Emiliano Jankowski"
                 },
                 components: nil,
                 created_at: _,
                 created_at_ago: _,
                 key: "SWE-0927",
                 status: "Complete",
                 summary: "Complete site Readme"
               }
             ] = data
    end

    @tag :jira_search_users
    test "Search users", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/api/3/user/search",
        fn conn ->
          Plug.Conn.resp(
            conn,
            200,
            LiveSup.Test.Core.Datasources.DataHelper.JiraListOfUsers.get()
          )
        end
      )

      {:ok, data} =
        JiraDatasource.search_user(
          "emiliano@livesup.com",
          token: "xxxx",
          domain: endpoint_url(bypass.port)
        )

      assert %{
               account_id: "5a390ef9280a8d389404e33a",
               active: true,
               avatar_url:
                 "https://avatar.public.atl-paas.net/5a390ef9280a8d389404e33a/53550071-f045-44f3-bc75-96956f8541c3/48",
               local: "en_US",
               time_zone: "America/New_York"
             } = data
    end

    @tag :jira_current_sprint_issues
    test "Get current sprint issues", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/agile/1.0/board/145/sprint",
        fn conn ->
          Plug.Conn.resp(conn, 200, @response)
        end
      )

      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/agile/1.0/sprint/431/issue",
        fn conn ->
          Plug.Conn.resp(conn, 200, current_sprint_issues())
        end
      )

      {:ok, data} =
        JiraDatasource.get_current_sprint_issues(
          "145",
          token: "xxxx",
          domain: endpoint_url(bypass.port)
        )

      assert [
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-14669",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-14668",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15232",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15233",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15234",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15235",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15603",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15331",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15291",
                 status: "Complete",
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
                 created_at: _,
                 created_at_ago: _,
                 key: "ENG-15132",
                 status: "Complete",
                 summary: "Swagger - fixing errors reported by Spectral linter "
               }
             ] = data
    end

    defp current_sprint_issues() do
      JiraCurrentSprintIssues.get()
    end

    defp statuses_response() do
      JiraProjectStatuses.get()
    end

    defp endpoint_url(port), do: "http://localhost:#{port}"
  end
end
