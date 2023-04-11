defmodule LiveSupWeb.Api.WidgetController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Widgets
  alias LiveSup.Schemas.Widget

  def index(conn, _params) do
    widgets = Widgets.all()
    render(conn, "index.json", widgets: widgets)
  end

  def create(conn, %{"widget" => widget_params}) do
    with {:ok, %Widget{} = widget} <- Widgets.create(widget_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/widgets/#{widget.id}")
      |> render("show.json", widget: widget)
    end
  end

  def show(conn, %{"id" => id}) do
    widget = Widgets.get!(id)
    render(conn, "show.json", widget: widget)
  end

  def update(conn, %{"id" => id, "widget" => widget_params}) do
    widget = Widgets.get!(id)

    with {:ok, %Widget{} = widget} <- Widgets.update(widget, widget_params) do
      render(conn, "show.json", widget: widget)
    end
  end

  def delete(conn, %{"id" => id}) do
    widget = Widgets.get!(id)

    with {:ok, %Widget{}} <- Widgets.delete(widget) do
      send_resp(conn, :no_content, "")
    end
  end
end
