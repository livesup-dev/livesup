defmodule LiveSupWeb.Test.Live.Widgets.ChuckNorrisLiveTest do
  use LiveSupWeb.ConnCase
  use ExUnit.Case
  alias LiveSupWeb.Live.Widgets.ChuckNorrisLive
  alias LiveSup.Schemas.{WidgetInstance, User}
  alias LiveSup.Core.Widgets.WidgetData

  # Bring render/3 and render_to_string/3 for testing custom views

  @widget_instance %WidgetInstance{
    id: "e15638c7-c777-4531-997a-8f9ce971ff08",
    settings: %{},
    widget: %LiveSup.Schemas.Widget{
      worker_handler: "LiveSup.Core.Widgets.ChuckNorrisJoke.Worker"
    },
    datasource_instance: %LiveSup.Schemas.DatasourceInstance{
      settings: %{}
    }
  }

  @widget_data %WidgetData{
    id: "066f884d-cc7a-4ed0-b46b-36fc4603a879",
    data: "Chuck Norris smokes chains.",
    state: :ready,
    title: "Chuck Norris's jokes",
    updated_in_minutes: "xxxxxx"
  }

  @current_user %User{
    id: "da400da9-b255-4711-a612-25aa3eb4f4d1",
    email: "myemail@awesome.com"
  }

  @assigns %{
    widget_data: @widget_data,
    current_user: @current_user,
    widget_instance: @widget_instance
  }

  @tag :chuck_norris_live
  @tag :skip
  test "rendering the joke" do
    # TODO: There is probably a better way of doing this
    # but didn't find any
    html =
      @assigns
      |> ChuckNorrisLive.render_widget()
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert html =~ "Chuck Norris&#39;s jokes"
  end
end
