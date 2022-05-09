defmodule LiveSup.Test.Core.LinksTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  alias LiveSup.Core.Links
  alias LiveSup.Test.{LinkFixtures, AccountsFixtures}

  describe "links" do
    @describetag :links
    def setup_links(_) do
      user = AccountsFixtures.user_fixture()

      jira_link = LinkFixtures.add_jira_link(user)
      pager_duty_link = LinkFixtures.add_pager_duty_link(user)

      %{jira_link: jira_link, pager_duty_link: pager_duty_link, user: user}
    end

    setup [:setup_links]

    test "get_jira_link/1", %{user: user} do
      jira_link =
        user
        |> Links.get_jira_link()

      assert jira_link == {:ok, %LiveSup.Schemas.LinkSchemas.Jira{account_id: "1234"}}
    end
  end
end
