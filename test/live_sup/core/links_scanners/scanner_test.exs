defmodule LiveSup.Test.Core.LinksScanners.ScannerTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase
  import Mock

  alias LiveSup.Test.{AccountsFixtures, DatasourcesFixtures}
  alias LiveSup.Core.LinksScanners.Scanner
  alias LiveSup.Queries.LinkQuery
  alias LiveSup.Schemas.Datasource
  alias LiveSup.Core.Datasources.JiraDatasource

  describe "scann/1" do
    @describetag :scanner
    setup [:setup_data]

    def setup_data(_) do
      datasource_instance = DatasourcesFixtures.add_jira_datasource_instance()
      user = AccountsFixtures.user_fixture()

      %{user: user, datasource_instance: datasource_instance}
    end

    test "without links", %{user: user, datasource_instance: datasource_instance} do
      with_mock JiraDatasource,
        search_user: fn _email_or_name, _args -> {:ok, jira_user()} end do
        user
        |> Scanner.scan_all()

        %{datasource_instance_id: created_datasource_instance_id} =
          user
          |> LinkQuery.get_by_datasource_instance(datasource_instance)

        assert created_datasource_instance_id == datasource_instance.id

        # Re run the scan to make sure it's not creating
        # duplicates entries
        user
        |> Scanner.scan_all()

        count =
          LinkQuery.get_by_datasource(user, Datasource.jira_slug())
          |> length()

        assert count == 1
      end
    end

    defp jira_user() do
      %{
        account_id: "5a390ef9280a8d389404e33a",
        active: true,
        avatar_url:
          "https://avatar.public.atl-paas.net/5a390ef9280a8d389404e33a/53550071-f045-44f3-bc75-96956f8541c3/48",
        local: "en_US",
        time_zone: "America/New_York"
      }
    end
  end
end
