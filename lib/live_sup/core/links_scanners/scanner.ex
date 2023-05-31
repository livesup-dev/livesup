defmodule LiveSup.Core.LinksScanners.Scanner do
  alias LiveSup.Schemas.{User, Datasource}
  alias LiveSup.Queries.UserQuery
  alias LiveSup.Core.Datasources

  def scan_all(%User{} = user) do
    # TODO: This is not great, we need to find
    # only enabled datasources
    Datasources.all!()
    |> Enum.each(fn datasource ->
      user |> scan(datasource)
    end)
  end

  def scan(%User{} = user, %Datasource{slug: slug}) do
    user |> scan(slug)
  end

  def scan(%User{} = user, datasource_slug) do
    with {:ok, scanner} <- Datasource.scanner(datasource_slug) do
      scanner.scan(user)
    end
  end

  def scan(user_id, datasource) do
    user_id
    |> UserQuery.get!()
    |> scan(datasource)
  end
end
