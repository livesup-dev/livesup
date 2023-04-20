defmodule LiveSupWeb.Api.SeedJSON do
  def show(%{result: result}) do
    %{status: result}
  end
end
