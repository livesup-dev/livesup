defmodule LiveSup.Core.Links do
  alias LiveSup.Schemas.LinkSchemas

  @moduledoc """
  The Projects context.
  """

  alias LiveSup.Schemas.{Link, User}
  alias LiveSup.Queries.LinkQuery

  defdelegate get(id), to: LinkQuery
  defdelegate get!(id), to: LinkQuery
  defdelegate get_by_datasource!(user, slug), to: LinkQuery
  defdelegate get_by_datasource(user, slug), to: LinkQuery
  defdelegate create(attrs), to: LinkQuery
  defdelegate create!(attrs), to: LinkQuery
  defdelegate update(team, attrs), to: LinkQuery
  defdelegate update!(team, attrs), to: LinkQuery
  defdelegate delete(team), to: LinkQuery

  def get_jira_link(%User{} = user) do
    get_by_datasource(user, Link.jira_slug())
    |> build_jira_link_schema()
  end

  def get_jira_link(user_id) when is_binary(user_id) do
    get_by_datasource(user_id, Link.jira_slug())
    |> build_jira_link_schema()
  end

  defp build_jira_link_schema(nil) do
    {:error, :jira_link_not_found}
  end

  defp build_jira_link_schema(%Link{settings: settings}) do
    {:ok, struct(LinkSchemas.Jira, account_id: settings["account_id"])}
  end
end
