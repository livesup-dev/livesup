defmodule LiveSup.Test.Core.Datasources.GithubDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Core.Datasources.GithubDatasource

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "Github datasource" do
    @describetag :datasource
    @describetag :github_datasource
    test "Get pull requests", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/repos/phoenixframework/phoenix/pulls", fn conn ->
        Plug.Conn.resp(conn, 200, response())
      end)

      data =
        GithubDatasource.get_pull_requests(
          "phoenixframework",
          "phoenix",
          token: "xxxx",
          endpoint: endpoint_url(bypass.port)
        )

      assert {:ok,
              [
                %{
                  title: "fix: mix phx.routes doc formatting",
                  short_title: "fix: mix phx.routes doc formatting"
                }
              ]} = data
    end

    test "Fail to get current sprint", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/repos/phoenixframework/phoenix/pulls", fn conn ->
        Plug.Conn.resp(conn, 401, failed_response())
      end)

      data =
        GithubDatasource.get_pull_requests(
          "phoenixframework",
          "phoenix",
          token: "xxxx",
          endpoint: endpoint_url(bypass.port)
        )

      assert {:error, "401: Bad credentials"} = data
    end

    @tag :search_pull_requests
    test "search pull requests", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/search/issues",
        fn conn ->
          Plug.Conn.resp(conn, 200, response_search_pull_requests())
        end
      )

      data =
        GithubDatasource.search_pull_requests(
          "phoenixframework",
          "phoenix",
          token: "xxxx",
          endpoint: endpoint_url(bypass.port)
        )

      assert {:ok,
              [
                %{
                  title: "Init",
                  short_title: "Init",
                  state: "open",
                  repo: %{
                    name: "oban-admin",
                    owner: "livesup-dev",
                    html_url: "https://github.com/livesup-dev/oban-admin/pull/1"
                  }
                }
              ]} = data
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"

  defp failed_response() do
    """
    {
      "documentation_url": "https://docs.github.com/rest",
      "message": "Bad credentials"
    }
    """
  end

  defp response_search_pull_requests() do
    """
    {
      "total_count": 1,
      "incomplete_results": false,
      "items": [
          {
              "url": "https://api.github.com/repos/livesup-dev/oban-admin/issues/1",
              "repository_url": "https://api.github.com/repos/livesup-dev/oban-admin",
              "labels_url": "https://api.github.com/repos/livesup-dev/oban-admin/issues/1/labels{/name}",
              "comments_url": "https://api.github.com/repos/livesup-dev/oban-admin/issues/1/comments",
              "events_url": "https://api.github.com/repos/livesup-dev/oban-admin/issues/1/events",
              "html_url": "https://github.com/livesup-dev/oban-admin/pull/1",
              "id": 1629533472,
              "node_id": "PR_kwDOJGHxns5MUW6i",
              "number": 1,
              "title": "Init",
              "user": {
                  "login": "mustela",
                  "id": 325222,
                  "node_id": "MDQ6VXNlcjMyNTIyMg==",
                  "avatar_url": "https://avatars.githubusercontent.com/u/325222?v=4",
                  "gravatar_id": "",
                  "url": "https://api.github.com/users/mustela",
                  "html_url": "https://github.com/mustela",
                  "followers_url": "https://api.github.com/users/mustela/followers",
                  "following_url": "https://api.github.com/users/mustela/following{/other_user}",
                  "gists_url": "https://api.github.com/users/mustela/gists{/gist_id}",
                  "starred_url": "https://api.github.com/users/mustela/starred{/owner}{/repo}",
                  "subscriptions_url": "https://api.github.com/users/mustela/subscriptions",
                  "organizations_url": "https://api.github.com/users/mustela/orgs",
                  "repos_url": "https://api.github.com/users/mustela/repos",
                  "events_url": "https://api.github.com/users/mustela/events{/privacy}",
                  "received_events_url": "https://api.github.com/users/mustela/received_events",
                  "type": "User",
                  "site_admin": false
              },
              "labels": [],
              "state": "open",
              "locked": false,
              "assignee": null,
              "assignees": [],
              "milestone": null,
              "comments": 0,
              "created_at": "2023-03-17T15:44:23Z",
              "updated_at": "2023-03-17T17:11:34Z",
              "closed_at": null,
              "author_association": "MEMBER",
              "active_lock_reason": null,
              "draft": false,
              "pull_request": {
                  "url": "https://api.github.com/repos/livesup-dev/oban-admin/pulls/1",
                  "html_url": "https://github.com/livesup-dev/oban-admin/pull/1",
                  "diff_url": "https://github.com/livesup-dev/oban-admin/pull/1.diff",
                  "patch_url": "https://github.com/livesup-dev/oban-admin/pull/1.patch",
                  "merged_at": null
              },
              "body": null,
              "reactions": {
                  "url": "https://api.github.com/repos/livesup-dev/oban-admin/issues/1/reactions",
                  "total_count": 0,
                  "+1": 0,
                  "-1": 0,
                  "laugh": 0,
                  "hooray": 0,
                  "confused": 0,
                  "heart": 0,
                  "rocket": 0,
                  "eyes": 0
              },
              "timeline_url": "https://api.github.com/repos/livesup-dev/oban-admin/issues/1/timeline",
              "performed_via_github_app": null,
              "state_reason": null,
              "score": 1.0
          }
      ]
      }
    """
  end

  defp response() do
    """
    [
      {
        "url": "https://api.github.com/repos/phoenixframework/phoenix/pulls/4565",
        "id": 767504535,
        "node_id": "PR_kwDOAPU_ic4tvzCX",
        "html_url": "https://github.com/phoenixframework/phoenix/pull/4565",
        "diff_url": "https://github.com/phoenixframework/phoenix/pull/4565.diff",
        "patch_url": "https://github.com/phoenixframework/phoenix/pull/4565.patch",
        "issue_url": "https://api.github.com/repos/phoenixframework/phoenix/issues/4565",
        "number": 4565,
        "state": "open",
        "locked": false,
        "title": "fix: mix phx.routes doc formatting",
        "user": {
            "login": "StephaneRob",
            "id": 4135765,
            "node_id": "MDQ6VXNlcjQxMzU3NjU=",
            "avatar_url": "https://avatars.githubusercontent.com/u/4135765?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/StephaneRob",
            "html_url": "https://github.com/StephaneRob",
            "followers_url": "https://api.github.com/users/StephaneRob/followers",
            "following_url": "https://api.github.com/users/StephaneRob/following{/other_user}",
            "gists_url": "https://api.github.com/users/StephaneRob/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/StephaneRob/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/StephaneRob/subscriptions",
            "organizations_url": "https://api.github.com/users/StephaneRob/orgs",
            "repos_url": "https://api.github.com/users/StephaneRob/repos",
            "events_url": "https://api.github.com/users/StephaneRob/events{/privacy}",
            "received_events_url": "https://api.github.com/users/StephaneRob/received_events",
            "type": "User",
            "site_admin": false
        },
        "body": null,
        "created_at": "2021-10-27T14:54:51Z",
        "updated_at": "2021-10-27T14:54:51Z",
        "closed_at": null,
        "merged_at": null,
        "merge_commit_sha": "7e699d216a78faa8e3d7a0b2c3d85a5143db651f",
        "assignee": null,
        "assignees": [],
        "requested_reviewers": [],
        "requested_teams": [],
        "labels": [],
        "milestone": null,
        "draft": false,
        "commits_url": "https://api.github.com/repos/phoenixframework/phoenix/pulls/4565/commits",
        "review_comments_url": "https://api.github.com/repos/phoenixframework/phoenix/pulls/4565/comments",
        "review_comment_url": "https://api.github.com/repos/phoenixframework/phoenix/pulls/comments{/number}",
        "comments_url": "https://api.github.com/repos/phoenixframework/phoenix/issues/4565/comments",
        "statuses_url": "https://api.github.com/repos/phoenixframework/phoenix/statuses/a86880d60e96dec6e7d5211a1bdc9118cac56729",
        "head": {
            "label": "StephaneRob:fix-phx-routes-doc",
            "ref": "fix-phx-routes-doc",
            "sha": "a86880d60e96dec6e7d5211a1bdc9118cac56729",
            "user": {
                "login": "StephaneRob",
                "id": 4135765,
                "node_id": "MDQ6VXNlcjQxMzU3NjU=",
                "avatar_url": "https://avatars.githubusercontent.com/u/4135765?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/StephaneRob",
                "html_url": "https://github.com/StephaneRob",
                "followers_url": "https://api.github.com/users/StephaneRob/followers",
                "following_url": "https://api.github.com/users/StephaneRob/following{/other_user}",
                "gists_url": "https://api.github.com/users/StephaneRob/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/StephaneRob/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/StephaneRob/subscriptions",
                "organizations_url": "https://api.github.com/users/StephaneRob/orgs",
                "repos_url": "https://api.github.com/users/StephaneRob/repos",
                "events_url": "https://api.github.com/users/StephaneRob/events{/privacy}",
                "received_events_url": "https://api.github.com/users/StephaneRob/received_events",
                "type": "User",
                "site_admin": false
            },
            "repo": {
                "id": 124076708,
                "node_id": "MDEwOlJlcG9zaXRvcnkxMjQwNzY3MDg=",
                "name": "phoenix",
                "full_name": "StephaneRob/phoenix",
                "private": false,
                "owner": {
                    "login": "StephaneRob",
                    "id": 4135765,
                    "node_id": "MDQ6VXNlcjQxMzU3NjU=",
                    "avatar_url": "https://avatars.githubusercontent.com/u/4135765?v=4",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/StephaneRob",
                    "html_url": "https://github.com/StephaneRob",
                    "followers_url": "https://api.github.com/users/StephaneRob/followers",
                    "following_url": "https://api.github.com/users/StephaneRob/following{/other_user}",
                    "gists_url": "https://api.github.com/users/StephaneRob/gists{/gist_id}",
                    "starred_url": "https://api.github.com/users/StephaneRob/starred{/owner}{/repo}",
                    "subscriptions_url": "https://api.github.com/users/StephaneRob/subscriptions",
                    "organizations_url": "https://api.github.com/users/StephaneRob/orgs",
                    "repos_url": "https://api.github.com/users/StephaneRob/repos",
                    "events_url": "https://api.github.com/users/StephaneRob/events{/privacy}",
                    "received_events_url": "https://api.github.com/users/StephaneRob/received_events",
                    "type": "User",
                    "site_admin": false
                },
                "html_url": "https://github.com/StephaneRob/phoenix",
                "description": "Productive. Reliable. Fast.",
                "fork": true,
                "url": "https://api.github.com/repos/StephaneRob/phoenix",
                "forks_url": "https://api.github.com/repos/StephaneRob/phoenix/forks",
                "keys_url": "https://api.github.com/repos/StephaneRob/phoenix/keys{/key_id}",
                "collaborators_url": "https://api.github.com/repos/StephaneRob/phoenix/collaborators{/collaborator}",
                "teams_url": "https://api.github.com/repos/StephaneRob/phoenix/teams",
                "hooks_url": "https://api.github.com/repos/StephaneRob/phoenix/hooks",
                "issue_events_url": "https://api.github.com/repos/StephaneRob/phoenix/issues/events{/number}",
                "events_url": "https://api.github.com/repos/StephaneRob/phoenix/events",
                "assignees_url": "https://api.github.com/repos/StephaneRob/phoenix/assignees{/user}",
                "branches_url": "https://api.github.com/repos/StephaneRob/phoenix/branches{/branch}",
                "tags_url": "https://api.github.com/repos/StephaneRob/phoenix/tags",
                "blobs_url": "https://api.github.com/repos/StephaneRob/phoenix/git/blobs{/sha}",
                "git_tags_url": "https://api.github.com/repos/StephaneRob/phoenix/git/tags{/sha}",
                "git_refs_url": "https://api.github.com/repos/StephaneRob/phoenix/git/refs{/sha}",
                "trees_url": "https://api.github.com/repos/StephaneRob/phoenix/git/trees{/sha}",
                "statuses_url": "https://api.github.com/repos/StephaneRob/phoenix/statuses/{sha}",
                "languages_url": "https://api.github.com/repos/StephaneRob/phoenix/languages",
                "stargazers_url": "https://api.github.com/repos/StephaneRob/phoenix/stargazers",
                "contributors_url": "https://api.github.com/repos/StephaneRob/phoenix/contributors",
                "subscribers_url": "https://api.github.com/repos/StephaneRob/phoenix/subscribers",
                "subscription_url": "https://api.github.com/repos/StephaneRob/phoenix/subscription",
                "commits_url": "https://api.github.com/repos/StephaneRob/phoenix/commits{/sha}",
                "git_commits_url": "https://api.github.com/repos/StephaneRob/phoenix/git/commits{/sha}",
                "comments_url": "https://api.github.com/repos/StephaneRob/phoenix/comments{/number}",
                "issue_comment_url": "https://api.github.com/repos/StephaneRob/phoenix/issues/comments{/number}",
                "contents_url": "https://api.github.com/repos/StephaneRob/phoenix/contents/{+path}",
                "compare_url": "https://api.github.com/repos/StephaneRob/phoenix/compare/{base}...{head}",
                "merges_url": "https://api.github.com/repos/StephaneRob/phoenix/merges",
                "archive_url": "https://api.github.com/repos/StephaneRob/phoenix/{archive_format}{/ref}",
                "downloads_url": "https://api.github.com/repos/StephaneRob/phoenix/downloads",
                "issues_url": "https://api.github.com/repos/StephaneRob/phoenix/issues{/number}",
                "pulls_url": "https://api.github.com/repos/StephaneRob/phoenix/pulls{/number}",
                "milestones_url": "https://api.github.com/repos/StephaneRob/phoenix/milestones{/number}",
                "notifications_url": "https://api.github.com/repos/StephaneRob/phoenix/notifications{?since,all,participating}",
                "labels_url": "https://api.github.com/repos/StephaneRob/phoenix/labels{/name}",
                "releases_url": "https://api.github.com/repos/StephaneRob/phoenix/releases{/id}",
                "deployments_url": "https://api.github.com/repos/StephaneRob/phoenix/deployments",
                "created_at": "2018-03-06T12:41:11Z",
                "updated_at": "2021-10-27T14:45:07Z",
                "pushed_at": "2021-10-27T14:53:48Z",
                "git_url": "git://github.com/StephaneRob/phoenix.git",
                "ssh_url": "git@github.com:StephaneRob/phoenix.git",
                "clone_url": "https://github.com/StephaneRob/phoenix.git",
                "svn_url": "https://github.com/StephaneRob/phoenix",
                "homepage": "http://www.phoenixframework.org",
                "size": 9111,
                "stargazers_count": 0,
                "watchers_count": 0,
                "language": "Elixir",
                "has_issues": false,
                "has_projects": true,
                "has_downloads": true,
                "has_wiki": false,
                "has_pages": false,
                "forks_count": 0,
                "mirror_url": null,
                "archived": false,
                "disabled": false,
                "open_issues_count": 0,
                "license": {
                    "key": "mit",
                    "name": "MIT License",
                    "spdx_id": "MIT",
                    "url": "https://api.github.com/licenses/mit",
                    "node_id": "MDc6TGljZW5zZTEz"
                },
                "allow_forking": true,
                "is_template": false,
                "topics": [],
                "visibility": "public",
                "forks": 0,
                "open_issues": 0,
                "watchers": 0,
                "default_branch": "master"
            }
        },
        "base": {
            "label": "phoenixframework:master",
            "ref": "master",
            "sha": "518a4640a70aa4d1370a64c2280d598e5b928168",
            "user": {
                "login": "phoenixframework",
                "id": 6510388,
                "node_id": "MDEyOk9yZ2FuaXphdGlvbjY1MTAzODg=",
                "avatar_url": "https://avatars.githubusercontent.com/u/6510388?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/phoenixframework",
                "html_url": "https://github.com/phoenixframework",
                "followers_url": "https://api.github.com/users/phoenixframework/followers",
                "following_url": "https://api.github.com/users/phoenixframework/following{/other_user}",
                "gists_url": "https://api.github.com/users/phoenixframework/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/phoenixframework/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/phoenixframework/subscriptions",
                "organizations_url": "https://api.github.com/users/phoenixframework/orgs",
                "repos_url": "https://api.github.com/users/phoenixframework/repos",
                "events_url": "https://api.github.com/users/phoenixframework/events{/privacy}",
                "received_events_url": "https://api.github.com/users/phoenixframework/received_events",
                "type": "Organization",
                "site_admin": false
            },
            "repo": {
                "id": 16072585,
                "node_id": "MDEwOlJlcG9zaXRvcnkxNjA3MjU4NQ==",
                "name": "phoenix",
                "full_name": "phoenixframework/phoenix",
                "private": false,
                "owner": {
                    "login": "phoenixframework",
                    "id": 6510388,
                    "node_id": "MDEyOk9yZ2FuaXphdGlvbjY1MTAzODg=",
                    "avatar_url": "https://avatars.githubusercontent.com/u/6510388?v=4",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/phoenixframework",
                    "html_url": "https://github.com/phoenixframework",
                    "followers_url": "https://api.github.com/users/phoenixframework/followers",
                    "following_url": "https://api.github.com/users/phoenixframework/following{/other_user}",
                    "gists_url": "https://api.github.com/users/phoenixframework/gists{/gist_id}",
                    "starred_url": "https://api.github.com/users/phoenixframework/starred{/owner}{/repo}",
                    "subscriptions_url": "https://api.github.com/users/phoenixframework/subscriptions",
                    "organizations_url": "https://api.github.com/users/phoenixframework/orgs",
                    "repos_url": "https://api.github.com/users/phoenixframework/repos",
                    "events_url": "https://api.github.com/users/phoenixframework/events{/privacy}",
                    "received_events_url": "https://api.github.com/users/phoenixframework/received_events",
                    "type": "Organization",
                    "site_admin": false
                },
                "html_url": "https://github.com/phoenixframework/phoenix",
                "description": "Peace of mind from prototype to production",
                "fork": false,
                "url": "https://api.github.com/repos/phoenixframework/phoenix",
                "forks_url": "https://api.github.com/repos/phoenixframework/phoenix/forks",
                "keys_url": "https://api.github.com/repos/phoenixframework/phoenix/keys{/key_id}",
                "collaborators_url": "https://api.github.com/repos/phoenixframework/phoenix/collaborators{/collaborator}",
                "teams_url": "https://api.github.com/repos/phoenixframework/phoenix/teams",
                "hooks_url": "https://api.github.com/repos/phoenixframework/phoenix/hooks",
                "issue_events_url": "https://api.github.com/repos/phoenixframework/phoenix/issues/events{/number}",
                "events_url": "https://api.github.com/repos/phoenixframework/phoenix/events",
                "assignees_url": "https://api.github.com/repos/phoenixframework/phoenix/assignees{/user}",
                "branches_url": "https://api.github.com/repos/phoenixframework/phoenix/branches{/branch}",
                "tags_url": "https://api.github.com/repos/phoenixframework/phoenix/tags",
                "blobs_url": "https://api.github.com/repos/phoenixframework/phoenix/git/blobs{/sha}",
                "git_tags_url": "https://api.github.com/repos/phoenixframework/phoenix/git/tags{/sha}",
                "git_refs_url": "https://api.github.com/repos/phoenixframework/phoenix/git/refs{/sha}",
                "trees_url": "https://api.github.com/repos/phoenixframework/phoenix/git/trees{/sha}",
                "statuses_url": "https://api.github.com/repos/phoenixframework/phoenix/statuses/{sha}",
                "languages_url": "https://api.github.com/repos/phoenixframework/phoenix/languages",
                "stargazers_url": "https://api.github.com/repos/phoenixframework/phoenix/stargazers",
                "contributors_url": "https://api.github.com/repos/phoenixframework/phoenix/contributors",
                "subscribers_url": "https://api.github.com/repos/phoenixframework/phoenix/subscribers",
                "subscription_url": "https://api.github.com/repos/phoenixframework/phoenix/subscription",
                "commits_url": "https://api.github.com/repos/phoenixframework/phoenix/commits{/sha}",
                "git_commits_url": "https://api.github.com/repos/phoenixframework/phoenix/git/commits{/sha}",
                "comments_url": "https://api.github.com/repos/phoenixframework/phoenix/comments{/number}",
                "issue_comment_url": "https://api.github.com/repos/phoenixframework/phoenix/issues/comments{/number}",
                "contents_url": "https://api.github.com/repos/phoenixframework/phoenix/contents/{+path}",
                "compare_url": "https://api.github.com/repos/phoenixframework/phoenix/compare/{base}...{head}",
                "merges_url": "https://api.github.com/repos/phoenixframework/phoenix/merges",
                "archive_url": "https://api.github.com/repos/phoenixframework/phoenix/{archive_format}{/ref}",
                "downloads_url": "https://api.github.com/repos/phoenixframework/phoenix/downloads",
                "issues_url": "https://api.github.com/repos/phoenixframework/phoenix/issues{/number}",
                "pulls_url": "https://api.github.com/repos/phoenixframework/phoenix/pulls{/number}",
                "milestones_url": "https://api.github.com/repos/phoenixframework/phoenix/milestones{/number}",
                "notifications_url": "https://api.github.com/repos/phoenixframework/phoenix/notifications{?since,all,participating}",
                "labels_url": "https://api.github.com/repos/phoenixframework/phoenix/labels{/name}",
                "releases_url": "https://api.github.com/repos/phoenixframework/phoenix/releases{/id}",
                "deployments_url": "https://api.github.com/repos/phoenixframework/phoenix/deployments",
                "created_at": "2014-01-20T14:14:11Z",
                "updated_at": "2021-10-27T08:11:12Z",
                "pushed_at": "2021-10-27T14:54:52Z",
                "git_url": "git://github.com/phoenixframework/phoenix.git",
                "ssh_url": "git@github.com:phoenixframework/phoenix.git",
                "clone_url": "https://github.com/phoenixframework/phoenix.git",
                "svn_url": "https://github.com/phoenixframework/phoenix",
                "homepage": "https://www.phoenixframework.org",
                "size": 15263,
                "stargazers_count": 17319,
                "watchers_count": 17319,
                "language": "Elixir",
                "has_issues": true,
                "has_projects": false,
                "has_downloads": true,
                "has_wiki": false,
                "has_pages": false,
                "forks_count": 2313,
                "mirror_url": null,
                "archived": false,
                "disabled": false,
                "open_issues_count": 28,
                "license": {
                    "key": "mit",
                    "name": "MIT License",
                    "spdx_id": "MIT",
                    "url": "https://api.github.com/licenses/mit",
                    "node_id": "MDc6TGljZW5zZTEz"
                },
                "allow_forking": true,
                "is_template": false,
                "topics": [
                    "api-server",
                    "distributed",
                    "elixir",
                    "realtime",
                    "web-framework"
                ],
                "visibility": "public",
                "forks": 2313,
                "open_issues": 28,
                "watchers": 17319,
                "default_branch": "master"
            }
        },
        "_links": {
            "self": {
                "href": "https://api.github.com/repos/phoenixframework/phoenix/pulls/4565"
            },
            "html": {
                "href": "https://github.com/phoenixframework/phoenix/pull/4565"
            },
            "issue": {
                "href": "https://api.github.com/repos/phoenixframework/phoenix/issues/4565"
            },
            "comments": {
                "href": "https://api.github.com/repos/phoenixframework/phoenix/issues/4565/comments"
            },
            "review_comments": {
                "href": "https://api.github.com/repos/phoenixframework/phoenix/pulls/4565/comments"
            },
            "review_comment": {
                "href": "https://api.github.com/repos/phoenixframework/phoenix/pulls/comments{/number}"
            },
            "commits": {
                "href": "https://api.github.com/repos/phoenixframework/phoenix/pulls/4565/commits"
            },
            "statuses": {
                "href": "https://api.github.com/repos/phoenixframework/phoenix/statuses/a86880d60e96dec6e7d5211a1bdc9118cac56729"
            }
        },
        "author_association": "NONE",
        "auto_merge": null,
        "active_lock_reason": null
      }
    ]
    """
  end
end
