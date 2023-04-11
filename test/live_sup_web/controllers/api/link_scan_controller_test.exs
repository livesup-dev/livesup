defmodule LiveSupWeb.Api.LinkScanControllerTest do
  use LiveSupWeb.ConnCase
  import Mock

  alias LiveSup.Test.{AccountsFixtures, DatasourcesFixtures, LinksFixtures}
  alias LiveSup.Core.Datasources.JiraDatasource

  setup [:create_user_and_assign_valid_jwt, :setup_data]

  @create_attrs %{
    datasource: "jira-datasource"
  }

  describe "scan links" do
    @describetag :link_scan_request
    test "create links when email is found", %{conn: conn, user: %{id: user_id}} do
      with_mock JiraDatasource,
        search_user: fn _email_or_name, _args -> {:ok, jira_user()} end do
        conn = post(conn, "/api/users/#{user_id}/links/scan", @create_attrs)

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

    @describetag :link_scan_exists_request
    test "get links when they already exists", %{
      conn: conn,
      user: %{id: user_id} = user,
      datasource_instance: datasource_instance
    } do
      user
      |> LinksFixtures.add_jira_link(datasource_instance)

      conn = post(conn, ~p"/api/users/#{user_id}/links/scan", @create_attrs)

      assert [
               %{
                 "datasource_instance_id" => _,
                 "id" => _,
                 "settings" => %{"account_id" => "1234"},
                 "user_id" => ^user_id
               }
             ] = json_response(conn, 201)["data"]
    end

    @describetag :link_scan_with_name_request
    test "create links when email is not found", %{conn: conn, user: %{id: user_id, email: email}} do
      with_mocks([
        {JiraDatasource, [],
         [
           search_user: fn
             "John Doe", [token: "1234", domain: "livesup.jira.com"] ->
               {:ok, jira_user()}

             ^email, [token: "1234", domain: "livesup.jira.com"] ->
               {:error, :not_found}
           end
         ]}
      ]) do
        conn = post(conn, "/api/users/#{user_id}/links/scan", @create_attrs)

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

    @describetag :link_scan_not_found_request
    test "fail to create link when email is not found", %{
      conn: conn,
      user: %{id: user_id, email: email}
    } do
      with_mocks([
        {JiraDatasource, [],
         [
           search_user: fn
             "John Doe", [token: "1234", domain: "livesup.jira.com"] ->
               {:error, :not_found}

             ^email, [token: "1234", domain: "livesup.jira.com"] ->
               {:error, :not_found}
           end
         ]}
      ]) do
        conn = post(conn, "/api/users/#{user_id}/links/scan", @create_attrs)

        assert [%{"state" => "user_not_found"}] = json_response(conn, 201)["data"]
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
      time_zone: "America/New_York",
      name: "Pepe Jon",
      email: "pepe@john.com"
    }
  end
end
