defmodule LiveSupWeb.Live.Components.WidgetFooterComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="px-2 py-1 border-t border-gray-700">
        <div class="space-x-2 text-right">
          <span class="text-xs text-gray-500">Updated at <%= @widget_data.updated_in_minutes %></span>
        </div>
    </div>
    """
  end
end
