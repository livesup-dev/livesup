defmodule LiveSupWeb.ProjectLive.LiveComponents.TodoFormComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.Todos
  alias LiveSup.Schemas.Todo

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Todos.change(%Todo{}, %{project_id: project.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset =
      %Todo{}
      |> Todos.change(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    save(socket, socket.assigns.action, todo_params)
  end

  defp save(socket, :new, todo_params) do
    case Todos.create(todo_params) do
      {:ok, todo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> push_redirect(to: Routes.manage_todo_path(socket, :show, todo.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
