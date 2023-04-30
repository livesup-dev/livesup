defmodule LiveSupWeb.Live.Todo.Components.ColorsComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    assigns =
      assigns
      |> assign(:colors, ["bg-orange-900", "bg-orange-700", "bg-orange-300", "bg-orange-100"])

    ~H"""
    <div class="flex columns-6 gap-x-4">
      <span>Newer</span>
      <div :for={color <- @colors} class="relative flex">
        <div class="space-y-1.5">
          <div class={"h-4 w-4 rounded dark:ring-1 dark:ring-inset dark:ring-white/10 #{color}"}>
          </div>
        </div>
      </div>
      <span>Older</span>
    </div>
    """
  end
end
