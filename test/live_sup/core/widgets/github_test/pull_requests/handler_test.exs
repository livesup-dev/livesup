defmodule LiveSup.Test.Core.Widgets.Github.PullRequests.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.Github.PullRequests.Handler
  alias LiveSup.Core.Datasources.GithubDatasource

  describe "Managing Github Pull Requests" do
    @describetag :widget
    @describetag :github_pull_requests_widget
    @describetag :github_pull_requests_widget_handler

    @tag :open_pull_requests
    test "getting the open pull requests" do
      with_mock GithubDatasource,
        get_pull_requests: fn _owner, _repository, _filter -> {:ok, open_pull_requests()} end do
        data =
          %{
            "owner" => "phoenixframework",
            "repository" => "phoenix",
            "state" => "open",
            "token" => "xxxx",
            "limit" => 10
          }
          |> Handler.get_data()

        assert {
                 :ok,
                 [
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
                 ]
               } = data
      end
    end

    @tag :close_pull_requests
    test "getting the closed pull requests" do
      with_mock GithubDatasource,
        get_pull_requests: fn _owner, _repository, _filter -> {:ok, close_pull_requests()} end do
        data =
          %{
            "owner" => "phoenixframework",
            "repository" => "phoenix",
            "state" => "closed",
            "token" => "xxxx",
            "limit" => 10
          }
          |> Handler.get_data()

        assert {
                 :ok,
                 [
                   %{
                     html_url: "https://github.com/phoenixframework/phoenix/pull/4571",
                     name: "Change wording on Changelog",
                     number: 4571,
                     repo: %{html_url: "https://github.com/marcandre/phoenix", name: "phoenix"},
                     user: %{
                       avatar_url: "https://avatars.githubusercontent.com/u/33770?v=4",
                       html_url: "https://github.com/marcandre",
                       id: 33_770,
                       login: "marcandre"
                     },
                     merged_at: ~U[2021-10-29 22:03:49Z],
                     merged_at_ago: _
                   }
                 ]
               } = data
      end
    end

    def open_pull_requests() do
      [
        %{
          created_at: ~U[2021-10-27 14:54:51Z],
          created_at_ago: "2 days ago",
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
    end

    def close_pull_requests() do
      [
        %{
          html_url: "https://github.com/phoenixframework/phoenix/pull/4571",
          name: "Change wording on Changelog",
          number: 4571,
          repo: %{html_url: "https://github.com/marcandre/phoenix", name: "phoenix"},
          user: %{
            avatar_url: "https://avatars.githubusercontent.com/u/33770?v=4",
            html_url: "https://github.com/marcandre",
            id: 33_770,
            login: "marcandre"
          },
          merged_at: ~U[2021-10-29 22:03:49Z],
          merged_at_ago: "2 days ago"
        }
      ]
    end
  end
end
