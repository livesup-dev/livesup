defmodule LiveSupWeb.ProjectLive.LiveComponents.TodoFormComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.{Todos, Projects}
  alias LiveSup.Schemas.Todo

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Todos.change(%Todo{}, %{project_id: project.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:error, nil)
     |> assign(:todo, %Todo{})
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", todo_params, socket) do
    changeset =
      %Todo{}
      |> Todos.change(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", todo_params, socket) do
    save(socket, socket.assigns.action, todo_params)
  end

  defp save(%{assigns: %{project: project}} = socket, :new, todo_params) do
    case Projects.create_todo(project, todo_params) do
      {:ok, todo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> push_redirect(to: ~p"/todos/#{todo.id}/manage")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
