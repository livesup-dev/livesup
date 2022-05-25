defmodule LiveSupWeb.Api.LinkControllerTest do
  use LiveSupWeb.ConnCase

  alias LiveSup.Test.{LinksFixtures, AccountsFixtures}

  alias LiveSup.Schemas.Link

  @update_attrs %{
    settings: %{account_id: "4321"}
  }

  @invalid_attrs %{user_id: nil}

  setup [:create_user_and_assign_valid_jwt]

  describe "index" do
    @describetag :links_request

    @tag :links_get_all
    test "lists all links", %{conn: conn, user: %{id: user_id}} do
      conn = get(conn, Routes.api_user_link_path(conn, :index, user_id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create link" do
    @describetag :links_request

    setup [:setup_link]

    @tag :links_create
    test "renders link when data is valid", %{
      conn: conn,
      link: %{datasource_instance_id: datasource_instance_id}
    } do
      %{id: user_id} = AccountsFixtures.user_fixture()

      create_attrs = %{
        datasource_instance_id: datasource_instance_id,
        settings: %{account: "1234"}
      }

      conn = post(conn, Routes.api_user_link_path(conn, :create, user_id), link: create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_link_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "user_id" => ^user_id,
               "settings" => %{"account" => "1234"},
               "datasource_instance_id" => ^datasource_instance_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: %{id: user_id}} do
      conn = post(conn, Routes.api_user_link_path(conn, :create, user_id), link: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update link" do
    @describetag :links_request

    setup [:setup_link]

    @tag :links_update
    test "renders link when data is valid", %{
      conn: conn,
      link: %Link{id: id, datasource_instance_id: datasource_instance_id, user_id: user_id} = link
    } do
      conn = put(conn, Routes.api_link_path(conn, :update, link), link: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_link_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "settings" => %{"account_id" => "4321"},
               "datasource_instance_id" => ^datasource_instance_id,
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, link: link} do
      conn = put(conn, Routes.api_link_path(conn, :update, link), link: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete link" do
    @describetag :links_request

    setup [:setup_link]

    test "deletes chosen link", %{conn: conn, link: link} do
      conn = delete(conn, Routes.api_link_path(conn, :delete, link))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_link_path(conn, :show, link))
      end
    end
  end

  defp setup_link(%{user: user}) do
    link = LinksFixtures.add_jira_link(user)
    %{link: link}
  end
end
