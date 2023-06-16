defmodule LiveSup.Core.Links do
  alias LiveSup.Schemas.LinkSchemas

  @moduledoc """
  The Projects context.
  """

  alias LiveSup.Schemas.{Link, User, DatasourceInstance, Datasource}
  alias LiveSup.Queries.LinkQuery

  defdelegate count(), to: LinkQuery
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
  defdelegate upsert(attrs), to: LinkQuery

  def get(%User{} = user, %DatasourceInstance{id: datasource_instance_id}) do
    user
    |> get_by_datasource_instance(datasource_instance_id)
    |> build_link_schema()
  end

  def get_jira_link(%User{} = user, %DatasourceInstance{id: datasource_instance_id}) do
    user
    |> get_by_datasource_instance(datasource_instance_id)
    |> build_link_schema()
  end

  def get_from_github_username(username) do
    LinkQuery.get_by_setting("username", username)
  end

  def get_from_github_username(username, %DatasourceInstance{} = datasource_instance) do
    LinkQuery.get_by_setting("username", username, datasource_instance)
  end

  def get_github_links(%User{} = user) do
    user
    |> get_by_datasource(Datasource.github_slug())
    |> build_links_schemas()
  end

  def get_jira_links(%User{} = user) do
    user
    |> get_by_datasource(Datasource.jira_slug())
    |> build_links_schemas()
  end

  def get_jira_links(user_id) do
    get_by_datasource(user_id, Datasource.jira_slug())
    |> build_links_schemas()
  end

  defp build_links_schemas([]) do
    {:error, :links_not_found}
  end

  defp build_links_schemas(links) do
    links
    |> Enum.map(&build_link_schema/1)
  end

  defp build_link_schema(nil) do
    {:error, :no_link_found}
  end

  defp build_link_schema(%Link{settings: settings, datasource_slug: "jira-datasource"}) do
    {:ok, struct(LinkSchemas.Jira, account_id: settings["account_id"])}
  end

  defp build_link_schema(%Link{settings: settings, datasource_slug: "github-datasource"}) do
    {:ok, struct(LinkSchemas.Github, username: settings["username"])}
  end
end
