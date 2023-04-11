defmodule LiveSupWeb.Test.Live.SetupLiveTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  setup [:register_and_log_in_user, :setup_user_with_groups]

  describe "Index" do
    @describetag :setup
    @describetag :skip
    test "start setup", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/setup")

      assert html =~ "Create a project"
    end

    test "saves new project", %{conn: conn} do
      {:ok, _index_live, _html} = live(conn, ~p"/setup")

      # TODO: Fix validation
      # assert index_live
      #        |> form("#project-form", project: @invalid_attrs)
      #        |> render_change() =~ "can&#39;t be blank"

      # {:ok, _, html} =
      #   index_live
      #   |> form("#project-form", project: @create_attrs)
      #   |> render_submit()
      #   |> IO.inspect()

      # assert html =~ "Project created successfully"
      # assert html =~ "some name"
    end
  end
end
