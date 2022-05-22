defmodule LiveSup.Core.Widgets.WidgetManager do
  use DynamicSupervisor

  import Logger

  alias LiveSup.Core.Widgets.WidgetRegistry
  alias LiveSup.Schemas.{User, WidgetInstance}
  alias LiveSup.Core.Utils
  alias LiveSup.Core.Widgets.WidgetContext

  def start_link(_arg) do
    debug("WidgetManager: started")

    DynamicSupervisor.start_link(
      __MODULE__,
      [],
      name: name()
    )
  end

  def init(_arg) do
    debug("WidgetManager: init")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_widgets(widget_instances, %User{} = user) do
    debug("WidgetManager: start_widgets")

    widget_instances
    |> Enum.each(fn widget_instance ->
      debug("WidgetManager: starting <#{widget_instance.name}> widget")
      debug("WidgetManager: global: #{widget_instance.widget.global}")

      widget_instance
      |> WidgetContext.build(user)
      |> start_widget()

      # case widget_instance.widget.global do
      #   true -> start_widget(widget_instance)
      #   false -> start_widget(widget_instance, user)
      # end
    end)
  end

  def start_widget(%WidgetContext{widget_instance: widget_instance} = widget_context) do
    debug("WidgetManager: starting <#{widget_instance.name}> widget")

    DynamicSupervisor.start_child(
      __MODULE__,
      {
        Utils.convert_to_module(widget_instance.widget.worker_handler),
        widget_context
      }
    )
  end

  def start_widget(%WidgetInstance{} = widget_instance) do
    debug("WidgetManager: starting <#{widget_instance.name}> widget")

    context =
      widget_instance
      |> WidgetContext.build()

    DynamicSupervisor.start_child(
      __MODULE__,
      {
        Utils.convert_to_module(widget_instance.widget.worker_handler),
        context
      }
    )
  end

  def start_widget(%WidgetInstance{} = widget_instance, %User{} = user) do
    widget_instance
    |> WidgetContext.build(user)
    |> start_widget()
  end

  # def start_widget(%WidgetInstance{} = widget_instance, user_id) do
  #   debug("WidgetManager: starting <#{widget_instance.name}> user widget")
  #   debug("WidgetManager: starting <#{user_id}> user widget")
  #   # IO.inspect(:start_widget, label: :user_widget)

  #   DynamicSupervisor.start_child(
  #     __MODULE__,
  #     {
  #       Utils.convert_to_module(widget_instance.widget.worker_handler),
  #       # TODO Im not sure if this is the right way to pass 2 params
  #       [widget_instance, user_id]
  #     }
  #   )
  # end

  def stop_all do
    DynamicSupervisor.stop(__MODULE__, :ok)
  end

  def stop_widget(pid) when is_pid(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def stop_widget(name) do
    case Registry.lookup(WidgetRegistry.name(), name) do
      [{pid, _}] -> DynamicSupervisor.terminate_child(__MODULE__, pid)
      _ -> Logger.warn("Unable to locate process assigned to #{inspect(name)}")
    end
  end

  def stop_widgets() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.each(fn {_, pid, _, _} when is_pid(pid) ->
      DynamicSupervisor.terminate_child(__MODULE__, pid)
    end)
  end

  def name, do: __MODULE__

  def autostart_widgets() do
    # TODO: we should start all the
  end

  # def look_up(widget_name) do
  #   case Registry.lookup(WidgetSupervisor.registry_name(), widget_name) do
  #     [{pid, _}] -
  #   end
  # end
end
