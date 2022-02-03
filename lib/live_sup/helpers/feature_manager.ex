defmodule LiveSup.Helpers.FeatureManager do
  alias LiveSup.Helpers.DatasourceActor

  # https://github.com/tompave/fun_with_flags/issues/68
  def all do
    {:ok, features} = FunWithFlags.all_flags()

    features
    |> Enum.map(fn feature ->
      feature.name
    end)
  end

  def enabled_features_for(actor) do
    all()
    |> Enum.map(fn feature ->
      if enabled_for?(feature, actor) do
        feature
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
  end

  def enabled_for?(feature, actor) do
    FunWithFlags.enabled?(feature, for: actor)
  end

  def enable_for(feature, actor) do
    FunWithFlags.enable(feature, for_actor: actor)
  end

  def datasource do
    case FunWithFlags.enabled?(:mock_api) do
      true -> :dummy
      false -> :real
    end
  end

  def datasource(datasource_name) do
    case FunWithFlags.enabled?(:mock_api, for: %DatasourceActor{name: datasource_name}) do
      true -> :dummy
      false -> :real
    end
  end

  def disable_mock_api, do: FunWithFlags.disable(:mock_api)
  def enable_mock_api, do: FunWithFlags.enable(:mock_api)
end
