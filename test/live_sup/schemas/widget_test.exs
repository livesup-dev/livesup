defmodule LiveSup.Tests.Schemas.WidgetTest do
  use ExUnit.Case
  use LiveSup.DataCase

  alias LiveSup.Schemas.Widget

  @tag :widget_schema
  test "ui_settings/1" do
    ui_settings = Widget.ui_settings(%{"hello" => 1})

    assert %{
             "hello" => 1,
             "size" => 1
           } == ui_settings

    ui_settings = Widget.ui_settings(%{"size" => 5})

    assert %{
             "size" => 5
           } == ui_settings
  end
end
