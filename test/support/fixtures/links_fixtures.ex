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

  defp add_link(%User{id: user_id}, %DatasourceInstance{id: datasource_instance_id}, settings) do
    %{id: id} =
      %{
        datasource_instance_id: datasource_instance_id,
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
