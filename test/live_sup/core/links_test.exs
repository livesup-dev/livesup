defmodule LiveSup.Test.Core.LinksTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  alias LiveSup.Core.Links
  alias LiveSup.Test.{LinksFixtures, AccountsFixtures}

  describe "links" do
    @describetag :links
    def setup_links(_) do
      user = AccountsFixtures.user_fixture()

      jira_link = LinksFixtures.add_jira_link(user)
      pager_duty_link = LinksFixtures.add_pager_duty_link(user)
      github_link = LinksFixtures.add_github_link(user)

      %{
        jira_link: jira_link,
        pager_duty_link: pager_duty_link,
        user: user,
        github_link: github_link
      }
    end

    setup [:setup_links]

    test "get_jira_links/1", %{user: user} do
      jira_links =
        user
        |> Links.get_jira_links()

      assert jira_links == [ok: %LiveSup.Schemas.LinkSchemas.Jira{account_id: "1234"}]
    end

    test "get_github_links/1", %{user: user} do
      links =
        user
        |> Links.get_github_links()

      assert links == [ok: %LiveSup.Schemas.LinkSchemas.Github{username: "myuser"}]
    end
  end
end
