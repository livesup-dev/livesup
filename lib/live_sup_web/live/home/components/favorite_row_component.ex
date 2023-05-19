defmodule LiveSupWeb.Home.Components.FavoriteRowComponent do
  use LiveSupWeb, :component

  alias LiveSup.Schemas.{Dashboard, Project, Todo}

  attr(:entity, :map, required: true)

  def render(assigns) do
    ~H"""
    <div class={"w-48 shrink-0 rounded-lg bg-gradient-to-br #{color(@entity)} p-[3px]"}>
      <div class="rounded-lg bg-white p-3 dark:bg-navy-700">
        <div class="flex items-center justify-between">
          <p><.link navigate={entity_link(@entity)}><%= title(@entity) %></.link></p>
          <i class={"text-lg #{entity_icon(@entity)}"} x-tooltip.light={"'#{tooltip(@entity)}'"} />
        </div>
      </div>
    </div>
    """
  end

  defp title(%Project{} = entity), do: entity.name
  defp title(%Todo{} = entity), do: entity.title
  defp title(%Dashboard{} = entity), do: entity.name

  defp entity_icon(%Project{}), do: "fa-solid fa-diagram-project text-color-blue-500"
  defp entity_icon(%Todo{}), do: "fa-solid fa-list text-color-orange-500"
  defp entity_icon(%Dashboard{}), do: "fa-solid fa-chart-line text-color-green-500"

  defp tooltip(%Project{} = entity), do: "Project"
  defp tooltip(%Todo{} = entity), do: "Todo"
  defp tooltip(%Dashboard{} = entity), do: "Dashboard"

  defp color(%Project{} = entity), do: "from-amber-400 to-orange-600"
  defp color(%Todo{} = entity), do: "from-purple-500 to-indigo-600"
  defp color(%Dashboard{} = entity), do: "from-info to-info-focus"

  defp entity_link(%Project{} = entity), do: "/projects/#{entity.id}/board"
  defp entity_link(%Todo{} = entity), do: "/projects/#{entity.id}/board"
  defp entity_link(%Dashboard{} = entity), do: "/projects/#{entity.id}/board"
end
