defmodule LiveSup.Core.Datasources.Helper do
  def build_url(url: url, feature_flag: feature_flag) do
    build_url(
      url: url,
      mode: LiveSup.Helpers.FeatureManager.datasource(feature_flag)
    )
  end

  def build_url(url: url, mode: :dummy) do
    mock_api_host = LiveSup.Helpers.Configuration.mock_api_host()
    parsed_url = URI.parse(url)

    host_section = "#{parsed_url.scheme}://#{parsed_url.host}"
    String.replace(url, host_section, mock_api_host)
  end

  def build_url(url: url, mode: :real), do: url
end
