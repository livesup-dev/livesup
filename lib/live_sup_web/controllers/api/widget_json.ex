defmodule LiveSupWeb.Api.WidgetJSON do
  alias LiveSup.Schemas.Widget

  def index(%{widgets: widgets}) do
    %{data: for(widget <- widgets, do: data(widget))}
  end

  def show(%{widget: widget}) do
    %{data: data(widget)}
  end

  def data(%Widget{} = widget) do
    %{
      id: widget.id,
      name: widget.name,
      description: widget.description,
      ui_handler: widget.ui_handler,
      worker_handler: widget.worker_handler,
      slug: widget.slug,
      inserted_at: widget.inserted_at,
      updated_at: widget.updated_at
    }
  end
end
