defmodule LiveSupWeb.Api.LinkScanControllerTest do
  use LiveSupWeb.ConnCase
  import Mock

  alias LiveSup.Test.{AccountsFixtures, DatasourcesFixtures}
  alias LiveSup.Core.Datasources.JiraDatasource

  setup [:create_user_and_assign_valid_jwt, :setup_data]

  @create_attrs %{
    datasource: "jira"
  }

  describe "scan links" do
    @describetag :link_scan_request
    test "renders links when data is valid", %{conn: conn, user: %{id: user_id}} do
      with_mock JiraDatasource,
        search_user: fn _email_or_name, _args -> {:ok, jira_user()} end do
        conn = post(conn, Routes.api_user_link_scan_path(conn, :create, user_id), @create_attrs)

        assert [
                 %{
                   "datasource_instance_id" => _,
                   "id" => _,
                   "settings" => %{"account_id" => "5a390ef9280a8d389404e33a"},
                   "user_id" => ^user_id
                 }
               ] = json_response(conn, 201)["data"]
      end
    end
  end

  def setup_data(_) do
    datasource_instance = DatasourcesFixtures.add_jira_datasource_instance()
    user = AccountsFixtures.user_fixture()

    %{user: user, datasource_instance: datasource_instance}
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
