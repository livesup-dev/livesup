defmodule LiveSup.Test.Core.Widgets.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.ChuckNorrisJoke.Handler
  alias LiveSup.Core.Datasources.ChuckNorrisApiDatasource

  describe "Managing chuck jokes" do
    @describetag :widget
    @describetag :chuck_widget
    @describetag :chuck_widget_handler

    @random_joke "Fake joke."

    test "getting a joke" do
      with_mock ChuckNorrisApiDatasource,
        get_joke: fn -> {:ok, @random_joke} end do
        joke = Handler.get_data()

        assert {:ok, "Fake joke."} = joke
      end
    end
  end
end
