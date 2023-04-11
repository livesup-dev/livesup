defmodule LiveSupWeb.ProjectLive.LiveComponents.ProjectFormComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.Projects
  alias LiveSup.Schemas.Project

  @impl true
  def update(%{project: _project} = assigns, socket) do
    changeset = Projects.change(%Project{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:error, nil)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", project_params, socket) do
    changeset =
      %Project{}
      |> Projects.change(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", project_params, socket) do
    save(socket, socket.assigns.action, project_params)
  end

  defp save(socket, :new, project_params) do
    case Projects.create_public_project(project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_redirect(to: ~p"/projects")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
