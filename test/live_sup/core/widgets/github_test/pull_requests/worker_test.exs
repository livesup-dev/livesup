defmodule LiveSup.Test.Core.Widgets.Github.PullRequests.WorkerTest do
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Core.Widgets.Github.PullRequests.{
    Worker,
    Handler
  }

  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.{WidgetManager, WorkerTaskSupervisor}

  describe "Github Pull Requests widget" do
    @describetag :widget
    @describetag :github_pull_requests_widget
    @describetag :github_pull_requests_widget_worker

    @handler_response {
      :ok,
      [
        %{
          created_at: ~U[2021-10-27 14:54:51Z],
          created_at_ago: "6 hours ago",
          html_url: "https://github.com/phoenixframework/phoenix/pull/4565",
          name: "fix: mix phx.routes doc formatting",
          number: 4565,
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

    @widget_instance %WidgetInstance{
      id: "b358819d-a65c-46cd-b82c-cc9f251221cc",
      settings: %{
        "owner" => %{"source" => "local", "type" => "string", "value" => "phoenixframework"},
        "repository" => %{"source" => "local", "type" => "string", "value" => "phoenix"},
        "token" => %{"source" => "env", "type" => "string", "value" => "TOKEN"},
        "state" => %{"source" => "local", "type" => "string", "value" => "open"}
      },
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Github.PullRequests.Worker"
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    setup do
      WidgetManager.stop_widgets()

      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      :ok
    end

    test "getting pull requests" do
      with_mock Handler,
        get_data: fn _arg -> @handler_response end do
        {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

        WorkerTaskSupervisor.wait_for_completion()

        data = Worker.get_data(@widget_instance)

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: [
                   %{
                     created_at: ~U[2021-10-27 14:54:51Z],
                     created_at_ago: _,
                     html_url: "https://github.com/phoenixframework/phoenix/pull/4565",
                     name: "fix: mix phx.routes doc formatting",
                     number: 4565,
                     repo: %{html_url: "https://github.com/StephaneRob/phoenix", name: "phoenix"},
                     user: %{
                       avatar_url: "https://avatars.githubusercontent.com/u/4135765?v=4",
                       html_url: "https://github.com/StephaneRob",
                       id: 4_135_765,
                       login: "StephaneRob"
                     }
                   }
                 ],
                 state: :ready,
                 title: "phoenixframework/phoenix",
                 updated_in_minutes: _
               } = data
      end
    end
  end
end
