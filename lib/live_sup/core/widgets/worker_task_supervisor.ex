defmodule LiveSup.Core.Widgets.WorkerTaskSupervisor do
  import Logger

  def fetch_data(module, widget_instance) do
    # Task.Supervisor.start_child(__MODULE__, module, :fetch_and_push_data, [widget_instance], [restart: :transient])
    # :temporary means the task is never restarted
    debug("WorkerTaskSupervisor.fetch_data: #{module}")
    Task.Supervisor.async(__MODULE__, module, :fetch_data, [widget_instance], restart: :temporary)
  end

  def fetch_data(module, widget_instance, user) do
    # Task.Supervisor.start_child(__MODULE__, module, :fetch_and_push_data, [widget_instance], [restart: :transient])
    # :temporary means the task is never restarted
    debug("WorkerTaskSupervisor.fetch_data: #{module}")

    Task.Supervisor.async(__MODULE__, module, :fetch_data, [widget_instance, user],
      restart: :temporary
    )
  end

  # For tests: find all children spawned by this supervisor and wait until they finish.
  def wait_for_completion() do
    pids = Task.Supervisor.children(__MODULE__)
    Enum.each(pids, &Process.monitor/1)
    wait_for_pids(pids)
  end

  def number_of_running_tasks do
    Task.Supervisor.children(__MODULE__)
    |> length()
  end

  # TODO: This is ugly, but I coudn't find a way to make sure
  # the state of the WidgetServer genserver has the last data
  # from the task. I think the problem is that when a widget does Worker.get_data(...)
  # the message that is coming from the finished task can't be processed until
  # get_data finishes
  defp wait_for_pids([]), do: :timer.sleep(100)

  defp wait_for_pids(pids) do
    receive do
      {:DOWN, _ref, :process, pid, _reason} -> wait_for_pids(List.delete(pids, pid))
    end
  end
end
