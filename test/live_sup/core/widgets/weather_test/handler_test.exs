defmodule LiveSup.Test.Core.Widgets.Weather.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.Weather.Handler
  alias LiveSup.Core.Datasources.WeatherApiDatasource

  describe "Managing Weather API" do
    @describetag :widget
    @describetag :weather_widget
    @describetag :weather_handler

    @current_weather %{
      condition: "Partly cloudy",
      feelslike: 9.0,
      icon: "//cdn.weatherapi.com/weather/64x64/night/116.png",
      is_day: false,
      location: "London, London",
      temp: 10.0
    }

    @error {:error,
            %{"error" => %{"code" => 1002, "message" => "API key is invalid or not provided."}}}

    test "getting the current weather details" do
      with_mock WeatherApiDatasource,
        get_current_weather: fn _args -> {:ok, @current_weather} end do
        data =
          %{"key" => "xxx", "location" => "London"}
          |> Handler.get_data()

        assert {
                 :ok,
                 %{
                   condition: "Partly cloudy",
                   feelslike: 9.0,
                   is_day: false,
                   location: "London, London",
                   temp: 10.0,
                   icon: "//cdn.weatherapi.com/weather/64x64/night/116.png"
                 }
               } = data
      end
    end

    test "failing getting the current weather details" do
      with_mock WeatherApiDatasource,
        get_current_weather: fn _args -> @error end do
        data =
          %{"key" => "xxx", "location" => "London"}
          |> Handler.get_data()

        assert {:error, "1002: API key is invalid or not provided."} = data
      end
    end
  end
end
