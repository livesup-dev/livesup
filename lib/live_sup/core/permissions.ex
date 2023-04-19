defmodule LiveSupWeb.Core.Permissions do
  def load(nil), do: []

  def load(_user) do
    []
  end

  def get(nil), do: []

  def get(_user), do: []
end
