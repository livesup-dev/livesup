defmodule LiveSup.Helpers.Configuration do
  def mock_api_host do
    System.get_env("MOCK_API_HOST") ||
      Application.get_env(:live_sup, :config)[:mock_api_host] ||
      raise """
      environment variable MOCK_API_HOST is missing.
      For example: http://localhost:8080
      """
  end
end
