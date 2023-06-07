defmodule LiveSupWeb.Todo.Live.Components.BindKeyEventLoading do
  use Phoenix.Component
  attr(:id, :string, required: true)
  attr(:class, :string, default: "")

  slot(:inner_block, required: true)

  def key_up(assigns) do
    ~H"""
    <div id={@id} class={"relative #{@class}"}>
      <%= render_slot(@inner_block) %>
      <div
        id="loading-overlay"
        class="hidden phx-keyup-loading:flex absolute top-0 left-0 w-full h-full bg-white opacity-70 z-2 dark:bg-navy-400 rounded-lg"
      >
      </div>
      <div
        id="loading-spinner"
        role="status"
        class="hidden phx-keyup-loading:flex absolute -translate-x-1/2 -translate-y-1/2 top-2/4 left-1/2 z-4"
      >
        <div class="spinner is-elastic h-7 w-7 animate-spin rounded-full border-[3px] border-primary/30 border-r-primary dark:border-accent/30 dark:border-r-accent">
          <span class="sr-only">Loading...</span>
        </div>
      </div>
    </div>
    """
  end
end
