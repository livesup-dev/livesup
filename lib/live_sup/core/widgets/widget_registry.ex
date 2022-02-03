defmodule LiveSup.Core.Widgets.WidgetRegistry do
  def name do
    __MODULE__
  end

  def number_of_workers_running do
    Registry.count(name())
  end

  def registered_widgets_names() do
    pid = Process.whereis(__MODULE__)
    Registry.keys(__MODULE__, pid)
  end
end
