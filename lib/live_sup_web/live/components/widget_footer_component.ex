defmodule LiveSupWeb.Live.Components.WidgetFooterComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="ls-widget-footer">
      <div class="text-right">
        <p class="text-xs text-slate-400 dark:text-navy-300">
          Updated at <time><%= @widget_data.updated_in_minutes %></time>
        </p>
      </div>
    </div>
    """
  end
end
