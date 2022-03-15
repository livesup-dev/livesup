defmodule LiveSupWeb.Api.SeedView do
  use LiveSupWeb, :view

  def render("show.json", %{result: result}) do
    %{status: result}
  end
end
