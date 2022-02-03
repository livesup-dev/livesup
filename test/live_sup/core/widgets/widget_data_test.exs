defmodule LiveSup.Test.Core.Widgets.WidgetDataTest do
  use LiveSup.DataCase

  alias LiveSup.Core.Widgets.WidgetData

  @tag :widget_data
  test "build_ready/1" do
    widget_data =
      LiveSup.Core.Widgets.WidgetData.build_ready(
        id: "id",
        title: "this is the title",
        data: %{hello: :there},
        ui_settings: %{"size" => 2}
      )

    assert %WidgetData{
             id: "id",
             state: :ready,
             updated_in_minutes: _,
             title: "this is the title",
             data: %{hello: :there},
             ui_settings: %{}
           } = widget_data
  end
end
