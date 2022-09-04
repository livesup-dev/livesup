defmodule LiveSupWeb.Live.Auth.ProjectAuth do
  import Plug.Conn
  import LiveSupWeb.Live.AuthHelper
  import Phoenix.Controller
  alias LiveSup.Core.{Projects, Dashboards}
  alias LiveSup.Policies.{ProjectPolicy, DashboardPolicy}

  def ensure_access_to_project(conn, options \\ [])

  def ensure_access_to_project(%{params: %{"project_id" => project_id}} = conn, _options) do
    current_user = conn |> get_current_user()

    project = Projects.get!(project_id)

    case Bodyguard.permit(ProjectPolicy, :read, current_user, project) do
      :ok ->
        conn
        |> assign(:project, project)

      _ ->
        conn
        |> put_flash(:error, "Dashboard not found")
        |> fail()
    end
  end

  def ensure_access_to_project(
        %{params: %{"dashboard_id" => dashboard_id}} = conn,
        _options
      ) do
    current_user = conn |> get_current_user()

    with {:ok, dashboard} <- Dashboards.get_with_project(dashboard_id),
         :ok <- Bodyguard.permit(DashboardPolicy, :read, current_user, dashboard) do
      conn
      |> assign(:dashboard, dashboard)
    else
      _ ->
        conn
        |> put_flash(:error, "Dashboard not found")
        |> fail()
    end
  end

  # defmodule ExampleWeb.UserLive.InvalidNameError do
  #   defexception message: "invalid name", plug_status: 404
  # end

  def ensure_access_to_project(conn, _options), do: conn

  defp fail(conn) do
    conn
    |> put_root_layout({LiveSupWeb.LayoutView, :root})
    |> put_status(:not_found)
    |> Phoenix.Controller.put_view(LiveSupWeb.ErrorView)
    |> Phoenix.Controller.render("404.html")
    |> halt()
  end
end
