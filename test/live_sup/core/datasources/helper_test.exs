defmodule LiveSup.Test.Core.Datasources.HelperTest do
  use LiveSup.DataCase

  alias LiveSup.Core.Datasources.Helper

  @tag :datasource_helper
  test "build_url/2" do
    http_url = Helper.build_url(url: "http://www.hola.com/path/1", mode: :dummy)
    https_url = Helper.build_url(url: "https://www.hola.com/path/1", mode: :dummy)
    assert http_url == "http://docker.for.mac.localhost:8080/path/1"
    assert https_url == "http://docker.for.mac.localhost:8080/path/1"
  end
end
