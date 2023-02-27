defmodule LiveSupWeb.SetupLive.Components.ProjectComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Schemas.Project
  alias LiveSup.Core.Projects

  @impl true
  def update(%{current_user: current_user}, socket) do
    {:ok,
     socket
     |> assign_project(%Project{})
     |> assign_projects(current_user)}
  end

  @impl true
  def update(%{project: project, current_user: current_user}, socket) do
    {:ok,
     socket
     |> assign_project(project)
     |> assign_projects(current_user)}
  end

  def assign_project(socket, project) do
    changeset = Projects.change(project)

    socket |> assign(:changeset, changeset)
  end

  def assign_projects(socket, current_user) do
    socket
    |> assign(:projects, Projects.by_user(current_user))
  end

  @impl true
  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, :new, project_params)
  end

  def handle_event("project_selected", %{"project" => project_id}, socket) do
    socket
    |> notify_parent({:project_selected, project_id})
  end

  defp save_project(socket, :new, project_params) do
    case Projects.create_public_project(project_params) do
      {:ok, project} ->
        notify_parent(socket, {:created_project, project})

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def notify_parent(socket, data) do
    send(self(), data)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <span>
      <h3 class="text-xl text-gray-600 dark:text-gray-200 text-center">Create a project</h3>
      <.form
        :let={f}
        for={@changeset}
        id="project-form"
        phx-target={@myself}
        phx-submit="save"
        class="space-y-6"
      >
        <%= label(f, :name) %>
        <%= text_input(f, :name,
          class:
            "w-full px-4 py-2 border rounded-md dark:bg-darker dark:border-gray-700 focus:outline-none focus:ring focus:ring-primary-100 dark:focus:ring-primary-darker"
        ) %>
        <%= error_tag(f, :name) %>

        <div>
          <%= submit("Save",
            phx_disable_with: "Saving...",
            class:
              "w-full px-4 py-2 font-medium text-center text-white transition-colors duration-200 rounded-md bg-primary hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-1 dark:focus:ring-offset-darker"
          ) %>
        </div>
      </.form>
      <%= if length(@projects) > 0 do %>
        <p>Or</p>
        <form phx-change="project_selected" phx-target={@myself}>
          <label class="block text-left" style="max-width: 400px">
            <span class="text-gray-700">Select an existing one</span>
            <select name="project" id="project_list" class="form-select block w-full mt-1">
              <option value="">&nbsp;</option>
              <%= for project <- @projects do %>
                <option value={project.id}><%= project.name %></option>
              <% end %>
            </select>
          </label>
        </form>
      <% end %>
    </span>
    """
  end
end
