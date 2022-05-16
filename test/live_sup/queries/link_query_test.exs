defmodule LiveSup.Tests.Queries.LinkQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.LinkQuery
  alias LiveSup.Test.{LinksFixtures, AccountsFixtures}

  def setup_links(_) do
    user = AccountsFixtures.user_fixture()

    jira_link = LinksFixtures.add_jira_link(user)
    pager_duty_link = LinksFixtures.add_pager_duty_link(user)

    %{jira_link: jira_link, pager_duty_link: pager_duty_link, user: user}
  end

  setup [:setup_links]

  describe "managing links queries" do
    @describetag :link_query

    test "getting link details", %{jira_link: %{id: jira_link_id}} do
      jira_link = jira_link_id |> LinkQuery.get()
      assert jira_link.id == jira_link_id
    end

    test "getting link details by datasource and user", %{
      user: user,
      jira_link: jira_link
    } do
      found_jira_link = user |> LinkQuery.get_by_datasource("jira-datasource")
      assert [jira_link] == found_jira_link
    end

    test "deleting link", %{jira_link: jira_link} do
      {:ok, _link} = jira_link |> LinkQuery.delete()

      assert LinkQuery.get(jira_link.id) == nil
    end
  end
end
