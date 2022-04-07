defmodule LiveSupWeb.Output.PlotlyStaticComponent do
  use LiveSupWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, id: assigns.id)
    {:ok, push_event(socket, "plotly:#{socket.assigns.id}:init", %{"spec" => assigns.spec})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={"plotly-#{@id}"} phx-hook="PlotlyHook" phx-update="ignore" data-id={@id} class="w-full">
    </div>
    """
  end
end
