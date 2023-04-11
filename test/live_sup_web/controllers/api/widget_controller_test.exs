defmodule LiveSupWeb.Api.WidgetControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.WidgetsFixtures
  import LiveSup.Test.Setups

  alias LiveSup.Schemas.Widget

  @create_attrs %{
    description: "some description",
    name: "some name",
    slug: "some-slug",
    ui_handler: "some ui_handler",
    worker_handler: "some worker_handler",
    settings: %{},
    global: false
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    slug: "some updated slug",
    ui_handler: "some updated ui_handler",
    worker_handler: "some updated worker_handler"
  }
  @invalid_attrs %{description: nil, name: nil, slug: nil, ui_handler: nil, worker_handler: nil}

  setup [:create_user_and_assign_valid_jwt, :setup_datasource]

  describe "index" do
    @describetag :widgets_request

    test "lists all widgets", %{conn: conn} do
      conn = get(conn, ~p"/api/widgets")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create widget" do
    @describetag :widgets_request

    test "renders widget when data is valid", %{conn: conn, datasource: %{id: datasource_id}} do
      conn =
        post(conn, ~p"/api/widgets",
          widget: Map.merge(@create_attrs, %{datasource_id: datasource_id})
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/widgets/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name",
               "slug" => "some-slug",
               "ui_handler" => "some ui_handler",
               "worker_handler" => "some worker_handler"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/widgets", widget: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update widget" do
    @describetag :widgets_request

    setup [:create_widget]

    test "renders widget when data is valid", %{conn: conn, widget: %Widget{id: id} = widget} do
      conn = put(conn, ~p"/api/widgets/#{widget}", widget: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/widgets/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name",
               "slug" => "some updated slug",
               "ui_handler" => "some updated ui_handler",
               "worker_handler" => "some updated worker_handler"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, widget: widget} do
      conn = put(conn, ~p"/api/widgets/#{widget}", widget: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete widget" do
    @describetag :widgets_request
    setup [:create_widget]

    test "deletes chosen widget", %{conn: conn, widget: widget} do
      conn = delete(conn, ~p"/api/widgets/#{widget}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/widgets/#{widget}")
      end
    end
  end

  defp create_widget(_) do
    widget = widget_with_datasource_fixture(%{})
    %{widget: widget}
  end
end
