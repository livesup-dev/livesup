defmodule LiveSupWeb.Live.Components.WidgetFooterComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="ls-widget-footer">
      <div class="text-right">
        <p class="text-xs text-slate-400 dark:text-navy-300">
          Updated at
        </p>
        <p class="text-sm font-medium text-primary dark:text-accent-light">
          <%= @widget_data.updated_in_minutes %>
        </p>
      </div>
    </div>
    """
  end
end
