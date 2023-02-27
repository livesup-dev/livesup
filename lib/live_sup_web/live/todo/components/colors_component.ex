defmodule LiveSupWeb.Live.Todo.Components.ColorsComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    assigns =
      assigns
      |> assign(:colors, ["bg-orange-900", "bg-orange-700", "bg-orange-300", "bg-orange-100"])

    ~H"""
    <div class="min-w-0 flex-1 grid grid-cols-5 2xl:grid-cols-10 gap-x-4 gap-y-3 2xl:gap-x-2">
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
