defmodule LiveSupWeb.LayoutHelper do
  import Phoenix.Controller

  def put_setup_layout(conn, _opts) do
    conn
    |> put_root_layout({LiveSupWeb.LayoutView, :setup})
  end
end
