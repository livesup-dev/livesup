defmodule LiveSupWeb.Admin.ProjectLive.FormComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.Projects

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Projects.change(project)

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
    avatar_map =
      uploaded_entries(socket, :avatar)
      |> handle_avatar(socket)

    save_project(socket, socket.assigns.action, Map.merge(project_params, avatar_map))
  end

  defp handle_avatar({nil, _}, _socket), do: %{}
  defp handle_avatar({[], _}, _socket), do: %{}

  defp handle_avatar({entries, _}, socket) do
    IO.inspect(entries)
    avatar_entry = entries |> Enum.at(0)

    file_path =
      Phoenix.LiveView.Upload.consume_uploaded_entry(socket, avatar_entry, fn %{path: path} ->
        dest = Path.join("priv/static/uploads", Path.basename(path))
        File.cp!(path, dest)
        Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
      end)

    %{
      "avatar_url" => file_path
    }
  end

  defp save_project(socket, :edit, project_params) do
    case Projects.update(socket.assigns.project, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_project(socket, :new, project_params) do
    case Projects.create_public_project(project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
