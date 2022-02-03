defmodule LiveSup.Core.Widgets.WidgetData do
  @enforce_keys [:id, :state, :updated_in_minutes, :title]
  defstruct id: nil,
            icon: nil,
            icon_svg: nil,
            state: nil,
            data: nil,
            title: nil,
            updated_in_minutes: nil,
            ui_settings: %{}

  alias LiveSup.Core.Widgets.WidgetData
  alias LiveSup.Helpers.DateHelper

  def build_ready(id: id, title: title, data: data, ui_settings: ui_settings) do
    %WidgetData{
      id: id,
      title: title,
      updated_in_minutes: DateHelper.current_minutes(),
      state: :ready,
      data: data,
      ui_settings: ui_settings
    }
  end

  def build_in_progress(id: id, title: title, ui_settings: ui_settings) do
    %WidgetData{
      id: id,
      title: title,
      updated_in_minutes: DateHelper.current_minutes(),
      state: :in_progress,
      ui_settings: ui_settings
    }
  end

  def build_error(id: id, title: title, error: error, ui_settings: ui_settings) do
    %WidgetData{
      id: id,
      title: title,
      updated_in_minutes: DateHelper.current_minutes(),
      state: :error,
      data: %{error_description: error},
      ui_settings: ui_settings
    }
  end
end
