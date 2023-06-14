defmodule LiveSup.Test.LinksFixtures do
  alias LiveSup.Queries.LinkQuery
  alias LiveSup.Schemas.{User, DatasourceInstance}
  alias LiveSup.Schemas.LinkSchemas

  def add_jira_link(%User{} = user) do
    jira = %LinkSchemas.Jira{account_id: "1234"}

    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_jira_datasource_instance(), jira)
  end

  def add_jira_link(%User{} = user, %DatasourceInstance{} = datasource_instance) do
    jira = %LinkSchemas.Jira{account_id: "1234"}

    user
    |> add_link(datasource_instance, jira)
  end

  def add_jira_link(%User{} = user, %LinkSchemas.Jira{} = jira) do
    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_jira_datasource_instance(), jira)
  end

  def add_pager_duty_link(%User{} = user) do
    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_pager_duty_datasource_instance(), %{})
  end

  def add_github_link(%User{} = user) do
    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_github_datasource_instance(), %{
      username: "myuser"
    })
  end

  def add_github_link(%User{} = user, %LinkSchemas.Github{} = github) do
    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_github_datasource_instance(), github)
  end

  defp add_link(
         %User{id: user_id},
         %DatasourceInstance{id: datasource_instance_id, datasource: %{slug: datasource_slug}},
         settings
       ) do
    %{id: id} =
      %{
        datasource_instance_id: datasource_instance_id,
        datasource_slug: datasource_slug,
        user_id: user_id,
        settings: settings
      }
      |> LinkQuery.create!()

    # Let's read again the record
    # so we can get the associations
    id
    |> LinkQuery.get!()
  end
end
