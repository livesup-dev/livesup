defmodule LiveSup.Test.Core.Widgets.Wordpress.WordpressConfigTest do
  use LiveSup.DataCase

  alias LiveSup.Core.Widgets.Wordpress.WordpressConfig

  describe "Managing wordpress config" do
    @describetag :wordpress_config

    test "getting keys" do
      existing_keys =
        ["url", "application_password", "user"]
        |> Enum.sort()

      config_keys =
        WordpressConfig.keys()
        |> Enum.sort()

      assert existing_keys == config_keys
    end

    test "building config" do
      result =
        %{"url" => "http://url", "application_password" => "app_pass", "user" => "cool_user"}
        |> WordpressConfig.build()

      assert %WordpressConfig{
               url: "http://url",
               application_password: "app_pass",
               user: "cool_user"
             } == result
    end
  end
end
