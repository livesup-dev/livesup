defmodule LiveSupWeb.Admin.Components.FormMessageComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    # TODO: We have to improve the style of it
    ~H"""
    <p class="alert alert-info" role="alert" phx-click="lv:clear-flash" phx-value-key="info">
      <%= live_flash(@flash, :info) %>
    </p>

    <p class="alert alert-danger" role="alert" phx-click="lv:clear-flash" phx-value-key="error">
      <%= live_flash(@flash, :error) %>
    </p>
    """
  end
end
