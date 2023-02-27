defmodule LiveSupWeb.SetupLive.Components.DashboardComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.Projects

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Projects.change(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h3 class="text-xl text-gray-600 dark:text-gray-200 text-center">Create a project</h3>
      <.form
        :let={f}
        for={@changeset}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= label(f, :name) %>
        <%= text_input(f, :name) %>
        <%= error_tag(f, :name) %>

        <div>
          <%= submit("Save", phx_disable_with: "Saving...") %>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, :new, project_params)
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Projects.change(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  defp save_project(socket, :new, project_params) do
    case Projects.create(project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
