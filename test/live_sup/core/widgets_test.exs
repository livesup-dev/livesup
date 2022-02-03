defmodule LiveSup.Test.Core.WidgetsTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.ProjectsFixtures
  import LiveSup.Test.DatasourcesFixtures

  alias LiveSup.Core.{Widgets, Datasources}

  describe "widgets" do
    @describetag :widgets

    alias LiveSup.Schemas.Widget

    @name "Last Rollbar Errors"
    @valid_attrs %{
      name: @name,
      slug: "last-rollbar-errors",
      enabled: true,
      worker_handler: "LastRollbarErrors",
      ui_handler: "LastRollbarErrors",
      labels: [],
      global: true,
      settings: %{number_of_errors: 5}
    }
    @update_attrs %{name: "Last Rollbar Errors X", handler: "LastRollbarErrorsX"}
    @invalid_attrs %{name: nil, handler: nil}

    def widget_fixture(attrs \\ %{}) do
      datasource = datasource_fixture()

      {:ok, widget} =
        attrs
        |> Enum.into(%{
          name: "Last Rollbar Errors",
          slug: "last-rollbar-errors#{System.unique_integer()}",
          enabled: true,
          worker_handler: "LastRollbarErrors#{System.unique_integer()}",
          ui_handler: "LastRollbarErrors#{System.unique_integer()}",
          labels: [],
          global: true,
          settings: %{number_of_errors: 5},
          datasource_id: datasource.id
        })
        |> Widgets.create()

      # We have to reload the datasource
      # otherwise the settings attribute uses atoms
      # instead of strings
      Widgets.get!(widget.id)
    end

    test "all/0 returns all widgets" do
      widget = widget_fixture()
      assert Widgets.all() == [widget]
    end

    test "all/1 returns all widgets by datasource" do
      widget = widget_fixture()
      widget_fixture()
      assert Widgets.all(%{datasource_id: widget.datasource_id}) == [widget]
    end

    test "get!/1 returns the datasource with given id" do
      widget = widget_fixture()
      assert Widgets.get!(widget.id) == widget
    end

    test "create/1 with valid data creates a widget" do
      datasource = datasource_fixture()

      attrs = @valid_attrs |> Enum.into(%{datasource_id: datasource.id})

      assert {:ok, %Widget{} = widget} = Widgets.create(attrs)
      assert widget.labels == []
      assert widget.name == @name
      assert widget.settings == %{number_of_errors: 5}
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Widgets.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the widget" do
      widget = widget_fixture()
      assert {:ok, %Widget{} = widget} = Widgets.update(widget, @update_attrs)
      assert widget.labels == []
      assert widget.name == "Last Rollbar Errors X"
      assert widget.settings == %{"number_of_errors" => 5}
    end

    test "update/2 with invalid data returns error changeset" do
      widget = widget_fixture()
      assert {:error, %Ecto.Changeset{}} = Widgets.update(widget, @invalid_attrs)
      assert widget == Widgets.get!(widget.id)
    end

    test "delete/1 deletes the datasource" do
      widget = widget_fixture()
      assert {:ok, %Widget{}} = Widgets.delete(widget)
      assert_raise Ecto.NoResultsError, fn -> Widgets.get!(widget.id) end
    end

    test "change/1 returns a datasource changeset" do
      widget = widget_fixture()
      assert %Ecto.Changeset{} = Widgets.change(widget)
    end

    test "create_instance/2 create a widget instance" do
      project = project_fixture()
      datasource = datasource_fixture()

      {:ok, datasource_instance} =
        Datasources.create_instance(datasource, project, %{api_key: "xxxxxxxxxx"})

      widget = widget_fixture(%{datasource_id: datasource.id})

      {:ok, widget_instance} = Widgets.create_instance(widget, datasource_instance)

      assert widget_instance.name == widget.name
      assert widget_instance.settings == widget.settings
    end
  end
end
