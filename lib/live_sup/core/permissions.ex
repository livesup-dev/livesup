defmodule LiveSupWeb.Core.Permissions do
  def load(nil), do: []

  def load(user) do
    []
  end

  def get(nil), do: []

  def get(user), do: []
end
