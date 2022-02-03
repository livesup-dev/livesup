defmodule LiveSupWeb.Project.Components.ProjectFormComponent do
  use LiveSupWeb, :live_component
  alias LiveSup.Core.Projects
  alias LiveSup.Schemas.Project

  @impl true
  def update(assigns, socket) do
    changeset = Projects.change(%Project{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Projects.change(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    {entries, _} = uploaded_entries(socket, :avatar)
    avatar_entry = entries |> Enum.at(0)

    file_path =
      Phoenix.LiveView.Upload.consume_uploaded_entry(socket, avatar_entry, fn %{path: path} ->
        dest = Path.join("priv/static/uploads", Path.basename(path))
        File.cp!(path, dest)
        Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
      end)

    save_project(socket, socket.assigns.action, Map.put(project_params, "avatar_url", file_path))
  end

  defp save_project(socket, :new, project_params) do
    case Projects.create_public_project(project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project creted successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
