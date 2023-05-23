defmodule LiveSupWeb.Components.IconsComponent do
  use Phoenix.Component

  attr(:brand, :string, required: true)

  def brand_icon(%{brand: brand} = assigns) do
    assigns = assigns |> assign(:class, LiveSup.Views.TodoTaskHelper.task_icon(brand))

    ~H"""
    <i class={"text-lg #{@class}"}></i>
    """
  end
end
