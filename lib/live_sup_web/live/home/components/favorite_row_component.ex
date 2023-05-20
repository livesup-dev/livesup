defmodule LiveSupWeb.Home.Components.FavoriteRowComponent do
  use LiveSupWeb, :component

  alias LiveSup.Schemas.{Dashboard, Project, Todo}

  attr(:entity, :map, required: true)

  def render(assigns) do
    ~H"""
    <div class={"w-48 rounded-2xl border #{color(@entity)} p-4 dark:border-navy-600 "}>
      <div class="rounded-lg bg-white p-3 dark:bg-navy-700">
        <div class="flex items-center justify-between">
          <p>
            <.link
              navigate={entity_link(@entity)}
              class="text-slate-700 line-clamp-1 hover:text-primary focus:text-primary dark:text-navy-100 dark:hover:text-accent-light dark:focus:text-accent-light"
            >
              <%= title(@entity) %>
            </.link>
          </p>
          <i class={"text-lg #{entity_icon(@entity)}"} x-tooltip.light={"'#{tooltip(@entity)}'"} />
        </div>
      </div>
    </div>
    """
  end

  defp title(%Project{} = entity), do: entity.name
  defp title(%Todo{} = entity), do: entity.title
  defp title(%Dashboard{} = entity), do: entity.name

  defp entity_icon(%Project{}), do: "fa-solid fa-diagram-project text-blue-500"
  defp entity_icon(%Todo{}), do: "fa-solid fa-list text-orange-500"
  defp entity_icon(%Dashboard{}), do: "fa-solid fa-chart-line text-green-500"

  defp tooltip(%Project{}), do: "Project"
  defp tooltip(%Todo{}), do: "Todo"
  defp tooltip(%Dashboard{}), do: "Dashboard"

  defp color(%Project{}), do: "border-blue-150"
  defp color(%Todo{}), do: "border-blue-150"
  defp color(%Dashboard{}), do: "border-green-150"

  defp entity_link(%Project{} = entity), do: "/projects/#{entity.id}/board"
  defp entity_link(%Todo{} = entity), do: "/todos/#{entity.id}/manage"
  defp entity_link(%Dashboard{} = entity), do: "/dashboards/#{entity.id}"
end
