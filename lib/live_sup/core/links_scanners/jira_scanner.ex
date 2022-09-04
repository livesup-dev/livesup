defmodule LiveSup.Core.LinksScanners.JiraScanner do
  import Logger
  alias LiveSup.Core.Links
  alias LiveSup.Schemas.{User, LinkSchemas, DatasourceInstance, Datasource}
  alias LiveSup.Core.Datasources.JiraDatasource
  alias LiveSup.Queries.DatasourceInstanceQuery

  def scan(%User{} = user) do
    links =
      DatasourceInstanceQuery.by_datasource(Datasource.jira_slug())
      |> Enum.map(fn datasource_instance ->
        found_link =
          user
          |> Links.get_by_datasource_instance(datasource_instance)

        debug("JiraScanner:scan")

        case found_link do
          nil -> create_link(datasource_instance, user)
          link -> link
        end
      end)

    {:ok, links}
  end

  def scan(user_id) do
    %User{id: user_id}
    |> scan()
  end

  defp create_link(%{id: datasource_instance_id} = datasource_instance, %{id: user_id} = user) do
    case user |> find_link(datasource_instance) do
      {:ok, account_id} ->
        debug("JiraScanner:link_found:#{account_id}")

        %{
          datasource_instance_id: datasource_instance_id,
          user_id: user_id,
          settings: %LinkSchemas.Jira{account_id: account_id}
        }
        |> Links.create!()

      {:error, error} ->
        {:error, error}
    end
  end

  defp find_link(%{email: email} = user, datasource_instance) do
    case find_jira_account(email, datasource_instance) do
      {:ok, account_id} -> {:ok, account_id}
      # If we can't find the user by email, let's
      # try with the full name
      {:error, _error} -> find_jira_account(User.full_name(user), datasource_instance)
    end
  end

  defp find_jira_account(thing, datasource_instance) do
    %{"token" => token, "domain" => domain} =
      DatasourceInstance.get_settings(datasource_instance, ["token", "domain"])

    case JiraDatasource.search_user(thing, token: token, domain: domain) do
      {:ok, jira_user} -> {:ok, jira_user[:account_id]}
      {:error, error} -> {:error, error}
    end
  end
end
