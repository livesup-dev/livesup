defmodule LiveSup.Test.Core.Widgets.WidgetManagerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.{
    WidgetRegistry,
    ChuckNorrisJoke,
    Weather,
    WorkerTaskSupervisor,
    WidgetManager
  }

  alias LiveSup.Schemas.{WidgetInstance, User}

  describe "Managing widgets" do
    @describetag :widget_manager

    @handler_response {:ok, "Fake joke"}

    @handler_weather_response {:ok,
                               %{
                                 condition: "Partly cloudy",
                                 feelslike: 21.0,
                                 is_day: 0,
                                 location: "Mahon, Mahon",
                                 temp: 21.0
                               }}

    @handler_second_weather_response {:ok,
                                      %{
                                        condition: "Partly cloudy",
                                        feelslike: 21.0,
                                        is_day: 0,
                                        location: "Es Castell, Es Castell",
                                        temp: 21.0
                                      }}

    @widget_instance %WidgetInstance{
      id: "487b8ee0-4027-4b48-bdd1-d2924b853d46",
      settings: %{},
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.ChuckNorrisJoke.Worker"
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    @weather_widget_instance %WidgetInstance{
      id: "ab081886-76ba-4d49-b76b-afce09f40968",
      settings: %{"location" => "Mahon", "key" => "xxxxxx"},
      name: "mahon",
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Weather.Worker",
        global: false
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    @weather_second_widget_instance %WidgetInstance{
      id: "0e58bc64-d3ee-45d3-a81c-61c8079b6ba1",
      settings: %{"location" => "Es Castell", "key" => "xxxxxx"},
      name: "es-castell",
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.Weather.Worker",
        global: false
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    @tag :widget_manager_state
    test "checking WidgetSupervisor state" do
      # WidgetSupervisor should start when the Application starts
      # so we are making sure it's there
      pid = Process.whereis(:widget_supervisor)
      assert Process.alive?(pid)
    end

    setup do
      # Let's stop all existing process for each test
      WidgetManager.stop_widgets()

      :ok
    end

    @tag :start_widget
    test "start a widget" do
      with_mock ChuckNorrisJoke.Handler, get_data: fn -> @handler_response end do
        {:ok, pid} = WidgetManager.start_widget(@widget_instance)

        assert(Process.alive?(pid))

        WorkerTaskSupervisor.wait_for_completion()

        assert(
          %LiveSup.Core.Widgets.WidgetData{
            data: "Fake joke",
            state: :ready,
            title: "Chuck Norris's jokes",
            updated_in_minutes: _
          } = ChuckNorrisJoke.Worker.get_data(@widget_instance)
        )
      end
    end

    test "start a user widget" do
      with_mock(Weather.Handler,
        get_data: fn
          %{"key" => "xxxxxx", "location" => "Mahon"} ->
            @handler_weather_response

          %{"key" => "xxxxxx", "location" => "Es Castell"} ->
            @handler_second_weather_response
        end
      ) do
        user = %User{id: "08976b38-b52e-4cfd-aa7d-47ab6b087505"}
        second_user = %User{id: "2767ebf3-164d-45c7-a7cd-46d7f39d31a6"}

        {:ok, pid} = WidgetManager.start_widget(@weather_widget_instance, user)

        assert Process.alive?(pid)

        WorkerTaskSupervisor.wait_for_completion()

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: %{
                   condition: "Partly cloudy",
                   feelslike: 21.0,
                   is_day: 0,
                   location: "Mahon, Mahon",
                   temp: 21.0
                 },
                 state: :ready,
                 title: "Weather",
                 updated_in_minutes: _
               } = Weather.Worker.get_data(@weather_widget_instance, user)

        {:ok, pid} = WidgetManager.start_widget(@weather_second_widget_instance, second_user)

        WorkerTaskSupervisor.wait_for_completion()

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: %{
                   condition: "Partly cloudy",
                   feelslike: 21.0,
                   is_day: 0,
                   location: "Es Castell, Es Castell",
                   temp: 21.0
                 },
                 state: :ready,
                 title: "Weather",
                 updated_in_minutes: _
               } = Weather.Worker.get_data(@weather_second_widget_instance, second_user)

        assert Process.alive?(pid)
      end
    end

    @tag :start_all_widgets
    test "start all widgets" do
      with_mock(Weather.Handler,
        get_data: fn
          %{"key" => "xxxxxx", "location" => "Mahon"} ->
            @handler_weather_response

          %{"key" => "xxxxxx", "location" => "Es Castell"} ->
            @handler_second_weather_response
        end
      ) do
        user = %User{id: "9fd070b1-8dd5-444f-912e-f28b8af6a3c8"}

        [@weather_widget_instance, @weather_second_widget_instance]
        |> WidgetManager.start_widgets(user)

        WorkerTaskSupervisor.wait_for_completion()

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: %{
                   condition: "Partly cloudy",
                   feelslike: 21.0,
                   is_day: 0,
                   location: "Mahon, Mahon",
                   temp: 21.0
                 },
                 state: :ready,
                 title: "Weather"
               } = Weather.Worker.get_data(@weather_widget_instance, user)

        assert %LiveSup.Core.Widgets.WidgetData{
                 data: %{
                   condition: "Partly cloudy",
                   feelslike: 21.0,
                   is_day: 0,
                   location: "Es Castell, Es Castell",
                   temp: 21.0
                 },
                 state: :ready,
                 title: "Weather",
                 updated_in_minutes: _
               } = Weather.Worker.get_data(@weather_second_widget_instance, user)

        # TODO: Why can't I get the registered widgets?
        # assert WidgetRegistry.registered_widgets_names() == ["asdf"]
        assert WidgetRegistry.number_of_workers_running() == 2
      end
    end

    # @tag :start_widget_manually
    # test "start widget manually" do
    #   {:ok, _} = Weather.Worker.start_link(@weather_widget_instance, "my@email.com")
    # end
  end
end
