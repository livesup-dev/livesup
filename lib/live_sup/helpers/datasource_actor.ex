defmodule LiveSup.Helpers.DatasourceActor do
  defstruct name: nil
end

defimpl FunWithFlags.Actor, for: LiveSup.Helpers.DatasourceActor do
  def id(%{name: name}) do
    "data_source:#{name}"
  end
end
