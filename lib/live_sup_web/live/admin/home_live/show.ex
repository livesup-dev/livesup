defmodule LiveSupWeb.Admin.HomeLive.Show do
  use LiveSupWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:section, :home)}
  end
end
