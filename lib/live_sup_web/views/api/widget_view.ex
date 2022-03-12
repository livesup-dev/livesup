defmodule LiveSupWeb.Api.WidgetView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.WidgetView

  def render("index.json", %{widgets: widgets}) do
    %{data: render_many(widgets, WidgetView, "widget.json")}
  end

  def render("show.json", %{widget: widget}) do
    %{data: render_one(widget, WidgetView, "widget.json")}
  end

  def render("widget.json", %{widget: widget}) do
    %{
      id: widget.id,
      name: widget.name,
      description: widget.description,
      ui_handler: widget.ui_handler,
      worker_handler: widget.worker_handler,
      slug: widget.slug
    }
  end
end
