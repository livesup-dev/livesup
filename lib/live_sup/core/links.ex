defmodule LiveSup.Core.Links do
  alias LiveSup.Schemas.LinkSchemas

  @moduledoc """
  The Projects context.
  """

  alias LiveSup.Schemas.{Link, User, DatasourceInstance, Datasource}
  alias LiveSup.Queries.LinkQuery

  defdelegate get(id), to: LinkQuery
  defdelegate get!(id), to: LinkQuery
  defdelegate get_by_datasource(user, slug), to: LinkQuery
  defdelegate get_by_user(user), to: LinkQuery
  defdelegate get_by_datasource_instance(user, datasource_instance_id), to: LinkQuery
  defdelegate create(attrs), to: LinkQuery
  defdelegate create!(attrs), to: LinkQuery
  defdelegate update(team, attrs), to: LinkQuery
  defdelegate update!(team, attrs), to: LinkQuery
  defdelegate delete(team), to: LinkQuery

  def get_jira_link(%User{} = user, %DatasourceInstance{id: datasource_instance_id}) do
    user
    |> get_by_datasource_instance(datasource_instance_id)
    |> build_jira_link_schema()
  end

  def get_jira_links(%User{} = user) do
    get_by_datasource(user, Datasource.jira_slug())
    |> build_jira_links_schemas()
  end

  def get_jira_links(user_id) do
    get_by_datasource(user_id, Datasource.jira_slug())
    |> build_jira_links_schemas()
  end

  defp build_jira_links_schemas([]) do
    {:error, :jira_links_not_found}
  end

  defp build_jira_links_schemas(links) do
    links
    |> Enum.map(fn link ->
      link
      |> build_jira_link_schema()
    end)
  end

  defp build_jira_link_schema(nil) do
    {:error, :jira_link_not_found}
  end

  defp build_jira_link_schema(%Link{settings: settings}) do
    {:ok, struct(LinkSchemas.Jira, account_id: settings["account_id"])}
  end
end
