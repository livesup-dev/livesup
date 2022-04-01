defmodule LiveSupWeb.Test.Live.Admin.ProjectLive do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveSup.Test.{ProjectsFixtures, GroupsFixtures}

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_project(_) do
    all_users_group_fixture()

    project = project_fixture()
    %{project: project}
  end

  describe "Index" do
    @describetag :admin_projects

    setup [:register_and_log_in_user, :create_project]

    test "lists all projects", %{conn: conn, project: project} do
      {:ok, _index_live, html} = live(conn, Routes.admin_project_index_path(conn, :index))

      assert html =~ project.name
    end

    test "saves new project", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.admin_project_index_path(conn, :index))

      assert index_live |> element(~s{[href="/admin/projects/new"]}) |> render_click() =~
               "New Project"

      assert_patch(index_live, Routes.admin_project_index_path(conn, :new))

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#project-form", project: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_project_index_path(conn, :index))

      assert html =~ "Project created successfully"
      assert html =~ "some name"
    end

    test "updates project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, Routes.admin_project_index_path(conn, :index))

      assert index_live |> element("#project-#{project.id} a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(index_live, Routes.admin_project_index_path(conn, :edit, project))

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#project-form", project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_project_index_path(conn, :index))

      assert html =~ "Project updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, Routes.admin_project_index_path(conn, :index))

      assert index_live |> element("#project-#{project.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#project-#{project.id}")
    end
  end

  describe "Show" do
    @describetag :admin_projects

    setup [:register_and_log_in_user, :create_project]

    test "displays project", %{conn: conn, project: project} do
      {:ok, _show_live, html} = live(conn, Routes.admin_project_show_path(conn, :show, project))

      assert html =~ "Project Details"
      assert html =~ project.name
    end

    test "updates project within modal", %{conn: conn, project: project} do
      {:ok, show_live, _html} = live(conn, Routes.admin_project_show_path(conn, :show, project))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(show_live, Routes.admin_project_show_path(conn, :edit, project))

      assert show_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#project-form", project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_project_show_path(conn, :show, project))

      assert html =~ "Project updated successfully"
      assert html =~ "some updated name"
    end
  end
end
