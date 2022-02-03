defmodule LiveSupWeb.ErrorViewTest do
  use LiveSupWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(LiveSupWeb.ErrorView, "404.html", []) =~
             "404 - Oops! Page not found."
  end

  test "renders 500.html" do
    assert render_to_string(LiveSupWeb.ErrorView, "500.html", []) =~
             "500 - Oops! Something went wrong."
  end
end
