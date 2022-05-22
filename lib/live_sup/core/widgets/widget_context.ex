defmodule LiveSup.Core.Widgets.WidgetContext do
  alias LiveSup.Core.Widgets.WidgetData
  alias LiveSup.Schemas.{WidgetInstance, User}

  defstruct [:user, :widget_instance, widget_data: nil]

  def build(%WidgetInstance{} = widget_instance) do
    struct(__MODULE__, %{widget_instance: widget_instance, user: %User{}})
  end

  def build(%WidgetInstance{} = widget_instance, %User{} = user) do
    struct(__MODULE__, %{widget_instance: widget_instance, user: user})
  end

  def update_data(%__MODULE__{} = context, %WidgetData{} = widget_data) do
    context |> Map.put(:widget_data, widget_data)
  end
end
