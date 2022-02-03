defmodule LiveSup.Test.Core.Widgets.Wordpress.DirectorySizes.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.Wordpress.DirectorySizes.Handler
  alias LiveSup.Core.Datasources.WordpressDatasource
  alias LiveSup.Core.Widgets.Wordpress.WordpressConfig

  describe "Managing Wordpress.DirectorySizes handler" do
    @describetag :widget
    @describetag :wordpress_directory_sizes_widget
    @describetag :wordpress_directory_sizes_handler

    @error {:error, "401: Sorry, you are not allowed to do that."}

    test "getting the site directory sizes" do
      with_mock WordpressDatasource,
        directory_sizes: fn _args -> current_directory_sizes() end do
        data =
          %WordpressConfig{user: "user", application_password: "xxx", url: "http://testing.com"}
          |> Handler.get_data()

        assert {:ok,
                [
                  %{
                    "database_size" => %{
                      "debug" => "21.78 MB (22839296 bytes)",
                      "raw" => 22_839_296,
                      "size" => "21.78 MB"
                    },
                    "plugins_size" => %{
                      "debug" => "86.00 MB (90176646 bytes)",
                      "raw" => 90_176_646,
                      "size" => "86.00 MB"
                    },
                    "themes_size" => %{
                      "debug" => "25.53 MB (26774299 bytes)",
                      "raw" => 26_774_299,
                      "size" => "25.53 MB"
                    },
                    "total_size" => %{
                      "debug" => "715.89 MB (750669086 bytes)",
                      "raw" => 750_669_086,
                      "size" => "715.89 MB"
                    },
                    "uploads_size" => %{
                      "debug" => "532.32 MB (558177513 bytes)",
                      "raw" => 558_177_513,
                      "size" => "532.32 MB"
                    },
                    "wordpress_size" => %{
                      "debug" => "50.26 MB (52701332 bytes)",
                      "raw" => 52_701_332,
                      "size" => "50.26 MB"
                    }
                  }
                ]} = data
      end
    end

    test "failing getting the current wordpress_directory_sizes details" do
      with_mock WordpressDatasource,
        directory_sizes: fn _args -> @error end do
        data =
          %WordpressConfig{user: "user", application_password: "xxx", url: "http://testing.com"}
          |> Handler.get_data()

        assert {:error, "401: Sorry, you are not allowed to do that."} = data
      end
    end
  end

  def current_directory_sizes() do
    {:ok,
     [
       %{
         "database_size" => %{
           "debug" => "21.78 MB (22839296 bytes)",
           "raw" => 22_839_296,
           "size" => "21.78 MB"
         },
         "plugins_size" => %{
           "debug" => "86.00 MB (90176646 bytes)",
           "raw" => 90_176_646,
           "size" => "86.00 MB"
         },
         "raw" => 0,
         "themes_size" => %{
           "debug" => "25.53 MB (26774299 bytes)",
           "raw" => 26_774_299,
           "size" => "25.53 MB"
         },
         "total_size" => %{
           "debug" => "715.89 MB (750669086 bytes)",
           "raw" => 750_669_086,
           "size" => "715.89 MB"
         },
         "uploads_size" => %{
           "debug" => "532.32 MB (558177513 bytes)",
           "raw" => 558_177_513,
           "size" => "532.32 MB"
         },
         "wordpress_size" => %{
           "debug" => "50.26 MB (52701332 bytes)",
           "raw" => 52_701_332,
           "size" => "50.26 MB"
         }
       }
     ]}
  end
end
