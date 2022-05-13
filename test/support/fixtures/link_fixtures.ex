defmodule LiveSup.Test.LinkFixtures do
  alias LiveSup.Queries.LinkQuery
  alias LiveSup.Schemas.{User, Datasource}
  alias LiveSup.Schemas.LinkSchemas

  def add_jira_link(%User{} = user) do
    jira = %LinkSchemas.Jira{account_id: "1234"}

    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_jira_datasource(), jira)
  end

  def add_jira_link(%User{} = user, %LinkSchemas.Jira{} = jira) do
    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_jira_datasource(), jira)
  end

  def add_pager_duty_link(%User{} = user) do
    user
    |> add_link(LiveSup.Test.DatasourcesFixtures.add_pager_duty_datasource(), %{})
  end

  defp add_link(%User{id: user_id}, %Datasource{id: datasource_id}, settings) do
    %{
      datasource_id: datasource_id,
      user_id: user_id,
      settings: settings
    }
    |> LinkQuery.create!()
  end
end
