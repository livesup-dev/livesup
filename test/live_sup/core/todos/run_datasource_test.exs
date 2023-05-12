defmodule LiveSup.Core.Todos.RunDatasourceTest do
  use LiveSup.DataCase, async: false
  import Mock
  alias LiveSup.Core.Todos
  alias LiveSup.Queries.TodoDatasourceQuery
  alias Palette.Utils.DateHelper

  import LiveSup.Test.Setups

  alias LiveSup.Core.Datasources.{GithubDatasource, JiraDatasource}

  setup [
    :setup_default_bot,
    :setup_user,
    :setup_project,
    :setup_todo,
    :setup_github_datasource,
    :setup_jira_datasource,
    :setup_github_todo_datasource,
    :setup_jira_todo_datasource
  ]

  @handler_github_response {
    :ok,
    [
      %{
        updated_at: ~U[2021-04-16 11:42:39Z],
        updated_at_ago: "6 hours ago",
        created_at: ~U[2021-04-16 11:42:39Z],
        created_at_ago: "6 hours ago",
        html_url: "https://github.com/phoenixframework/phoenix/pull/4565",
        title: "fix: mix phx.routes doc formatting",
        body: nil,
        state: "open",
        id: "767504535",
        number: 4565,
        merged: false,
        closed: false,
        repo: %{html_url: "https://github.com/StephaneRob/phoenix", name: "phoenix"},
        user: %{
          avatar_url: "https://avatars.githubusercontent.com/u/4135765?v=4",
          html_url: "https://github.com/StephaneRob",
          id: 4_135_765,
          login: "StephaneRob"
        }
      }
    ]
  }

  @handler_jira_response {
    :ok,
    [
      %{
        id: "51564",
        description:
          "We should add new methods to {{NetworkPort}} and {{NetworkBondPort}} which handle assigning and un-assigning multiple VLANs to/from the port in a single call.This could be tricky and/or just kind of tedious, as there’s a number of _additional_ things we do when assigning/un-assigning a VLAN to/from a port.Today, here’s the operations we do on our “individual” assignment/un-assignment calls, *in addition* to the actual {{add_vlan_to_iface}} call:When *assigning* a new VLAN:* For Network Bond Ports** If this is the first VLAN being assigned on the port, and the port is *NOT* in “hybrid bonded” mode, we send an {{enable_lag_vlan}} task to Narwhal *before* the actual assign vlan to iface call.** If there’s an internet gateway associated to the vlan, we send a {{create_internet_gateway}} task to narwhal *after* the assign vlan to iface call** For individual Network Ports** We send an {{ensure_vlan}} task to each switch to make sure the VLAN record exists on both switches the server is connected to, even if it’s not the switch this port is connected to.** We send a {{create_internet_gateway}} task to each switch the server is connected to, even if it’s not the switch this port is connected to.*When *un-assigning* a VLAN:* For Network Bond Ports** We un-set the native VLAN on the port if we’re removing the next-to-last VLAN remaining on the port, or if the VLAN being removed is set as the native vlan on the port.** If this was the last instance of this particular VLAN being used on the switch, we also issue a {{delete_vnid}} task to narwhal to remove the vlan definition from the switch.** If this was the last instance of ANY VLAN assigned to this port, and the port was not in “hybrid bonded” mode, we send a {{disable_lag_Vlan}} task to narwhal.** We send a {{destroy_internet_gateway}} task to Narwhal if the VLAN is associated to an internet gateway** For Individual Network Ports** We un-set the native VLAN on the port if we’re removing the next-to-last VLAN remaining on the port, or if the VLAN being removed is set as the native VLAN on the port.** If this was the last instance of this particular VLAN being used on *either* switch in the switch pair, we also issue a {{delete_vnid}} task to narwhal to remove the vlan definition from both switches.** We send a {{destroy_internet_gateway}} task to Narwhal for both switches if this vlan was associated to an internet gateway and this was the last port associated to this vlan in the switch pair*So, as you can see, there’s quite a few edge/corner-cases we handle today for just assigning/un-assigning a single VLAN – and this will get even more complicated when assigning/un-assigning multiple VLAN at once, so it’s going to take some real work to make sure we get this right.*_NOTE REGARDING TASKS_* - We actually have a couple different tasks depending on the vlan “type”. For “old-style” facility-based vlans, tasks are named like {{ensure_vxlan}}, {{add_vlan_to_iface}}, etc. For “metro-based” vlans, or the “sprint-style” vlans, we have tasks like {{ensure_enhanced_vxlan}}, {{add_enhanced_vxlan_to_iface}}, etc.*_NOTE REGARDING INTERNET GATEWAYS_* - I don’t believe the internet gateway bits have been thoroughly tested, so my commentary here is just based on reading the code. It may change as the internet gateway epic moves towards completion this quarter.",
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
        created_at: "2021-04-16T11:42:39.759-0400" |> DateHelper.parse_date(),
        created_at_ago: "2021-04-16T11:42:39.759-0400" |> DateHelper.from_now(),
        key: "ENG-14669",
        status: "Complete",
        summary:
          "[API] Add bulk VLAN assign/unassign handlers to network_port and network_bond_port"
      },
      %{
        id: "51562",
        description:
          "Add a new endpoint similar to our existing {{/ports/{id}/unassign}} endpoint but which accepts a list of VLAN UUID’s or VNI’s, and proceeds to perform a “bulk” unassign operation on the port/in narwhal. This endpoint should validate that each provided VLAN UUID or VNI exists, belongs to the project, and is in the same facility/metro as the port, and is already assigned to the port.",
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
        created_at: "2021-04-16T11:42:39.759-0400" |> DateHelper.parse_date(),
        created_at_ago: "2021-04-16T11:42:39.759-0400" |> DateHelper.from_now(),
        key: "ENG-14668",
        status: "Complete",
        summary: "[API] Add bulk VLAN unassign endpoint"
      }
    ]
  }

  @tag :todos_run_datasource_github
  test "run github datasource", %{
    todo_github_datasource:
      %{datasource_instance: %{id: datasource_instance_id}} = todo_github_datasource
  } do
    with_mock GithubDatasource,
      search_pull_requests: fn _owner, _repo, _params -> @handler_github_response end do
      %{todo: todo} = todo_github_datasource = TodoDatasourceQuery.get!(todo_github_datasource.id)
      {:ok, new_tasks} = Todos.run_datasource(todo_github_datasource)

      tasks = Todos.get_tasks(todo.id)
      assert length(new_tasks) == 1
      assert length(tasks) == 1

      first_task = tasks |> Enum.at(0)
      assert first_task.title == "fix: mix phx.routes doc formatting"
      assert first_task.description == nil
      assert first_task.datasource_instance_id == datasource_instance_id
      assert first_task.tags == ["github", "phoenix"]
      assert first_task.external_metadata != %{}
      assert first_task.external_identifier == "767504535"
      assert first_task.inserted_at == ~N[2021-04-16 11:42:39]
      assert first_task.updated_at == ~N[2021-04-16 11:42:39]

      todo_github_datasource = TodoDatasourceQuery.get!(todo_github_datasource.id)
      assert todo_github_datasource.last_run_at != nil

      # Re run the same datasource and check that the task is not duplicated
      {:ok, _new_tasks} = Todos.run_datasource(todo_github_datasource)

      tasks = Todos.get_tasks(todo.id)
      assert length(tasks) == 1
    end
  end

  @tag :todos_run_datasource_jira
  test "run jira datasource", %{
    todo_jira_datasource:
      %{datasource_instance: %{id: datasource_instance_id}} = todo_jira_datasource
  } do
    with_mock JiraDatasource,
      get_current_sprint_issues: fn _board, _params -> @handler_jira_response end do
      %{todo: todo} = todo_jira_datasource = TodoDatasourceQuery.get!(todo_jira_datasource.id)
      {:ok, new_tasks} = Todos.run_datasource(todo_jira_datasource)

      tasks = Todos.get_tasks(todo.id)
      assert length(new_tasks) == 2
      assert length(tasks) == 2

      first_task = tasks |> Enum.at(0)

      assert first_task.title ==
               "[ENG-14669] - [API] Add bulk VLAN assign/unassign handlers to network_port and network_bond_port"

      assert first_task.description ==
               "We should add new methods to {{NetworkPort}} and {{NetworkBondPort}} which handle assigning and un-assigning multiple VLANs to/from the port in a single call.This could be tricky and/or just kind of tedious, as there’s a number of _additional_ things we do when assigning/un-assigning a VLAN to/from a port.Today, here’s the operations we do on our “individual” assignment/un-assignment calls, *in addition* to the actual {{add_vlan_to_iface}} call:When *assigning* a new VLAN:* For Network Bond Ports** If this is the first VLAN being assigned on the port, and the port is *NOT* in “hybrid bonded” mode, we send an {{enable_lag_vlan}} task to Narwhal *before* the actual assign vlan to iface call.** If there’s an internet gateway associated to the vlan, we send a {{create_internet_gateway}} task to narwhal *after* the assign vlan to iface call** For individual Network Ports** We send an {{ensure_vlan}} task to each switch to make sure the VLAN record exists on both switches the server is connected to, even if it’s not the switch this port is connected to.** We send a {{create_internet_gateway}} task to each switch the server is connected to, even if it’s not the switch this port is connected to.*When *un-assigning* a VLAN:* For Network Bond Ports** We un-set the native VLAN on the port if we’re removing the next-to-last VLAN remaining on the port, or if the VLAN being removed is set as the native vlan on the port.** If this was the last instance of this particular VLAN being used on the switch, we also issue a {{delete_vnid}} task to narwhal to remove the vlan definition from the switch.** If this was the last instance of ANY VLAN assigned to this port, and the port was not in “hybrid bonded” mode, we send a {{disable_lag_Vlan}} task to narwhal.** We send a {{destroy_internet_gateway}} task to Narwhal if the VLAN is associated to an internet gateway** For Individual Network Ports** We un-set the native VLAN on the port if we’re removing the next-to-last VLAN remaining on the port, or if the VLAN being removed is set as the native VLAN on the port.** If this was the last instance of this particular VLAN being used on *either* switch in the switch pair, we also issue a {{delete_vnid}} task to narwhal to remove the vlan definition from both switches.** We send a {{destroy_internet_gateway}} task to Narwhal for both switches if this vlan was associated to an internet gateway and this was the last port associated to this vlan in the switch pair*So, as you can see, there’s quite a few edge/corner-cases we handle today for just assigning/un-assigning a single VLAN – and this will get even more complicated when assigning/un-assigning multiple VLAN at once, so it’s going to take some real work to make sure we get this right.*_NOTE REGARDING TASKS_* - We actually have a couple different tasks depending on the vlan “type”. For “old-style” facility-based vlans, tasks are named like {{ensure_vxlan}}, {{add_vlan_to_iface}}, etc. For “metro-based” vlans, or the “sprint-style” vlans, we have tasks like {{ensure_enhanced_vxlan}}, {{add_enhanced_vxlan_to_iface}}, etc.*_NOTE REGARDING INTERNET GATEWAYS_* - I don’t believe the internet gateway bits have been thoroughly tested, so my commentary here is just based on reading the code. It may change as the internet gateway epic moves towards completion this quarter."

      assert first_task.datasource_instance_id == datasource_instance_id
      assert first_task.tags == ["jira"]
      assert first_task.external_metadata != %{}
      assert first_task.external_identifier == "51564"
      assert first_task.inserted_at == ~N[2021-04-16 11:42:39]
      assert first_task.updated_at == ~N[2021-04-16 11:42:39]

      todo_jira_datasource = TodoDatasourceQuery.get!(todo_jira_datasource.id)
      assert todo_jira_datasource.last_run_at != nil

      # Re run the same datasource and check that the task is not duplicated
      {:ok, _new_tasks} = Todos.run_datasource(todo_jira_datasource)

      tasks = Todos.get_tasks(todo.id)
      assert length(tasks) == 2
    end
  end
end
