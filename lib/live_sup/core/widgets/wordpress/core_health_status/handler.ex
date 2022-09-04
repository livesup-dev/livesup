defmodule LiveSup.Core.Widgets.Wordpress.CoreHealthStatus.Handler do
  alias LiveSup.Core.Datasources.WordpressDatasource
  alias LiveSup.Core.Widgets.Wordpress.WordpressConfig
  import Logger

  def get_data(%WordpressConfig{url: url} = config) do
    debug("Handler: #{url}")

    config
    |> WordpressDatasource.site_health()
    |> process_response()
  end

  defp process_response({:error, error}), do: {:error, error}

  defp process_response({:ok, response}) do
    response
    |> add_core_details()
    |> add_server_details()
  end

  defp add_core_details(%{"wp-core" => core} = data) do
    {data,
     %{
       wp_core: %{
         wp_version: %{label: core["version"]["label"], value: core["version"]["value"]},
         https_status: %{
           label: core["https_status"]["label"],
           value: core["https_status"]["value"]
         },
         blog_public: %{label: core["blog_public"]["label"], value: core["blog_public"]["value"]}
       }
     }}
  end

  defp add_server_details({%{"wp-server" => %{"php_version" => %{"value" => value}}}, details}) do
    {:ok,
     details
     |> Map.merge(%{
       php_version: value
     })}
  end
end
