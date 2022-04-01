defmodule LiveSupWeb.UserSettingsView do
  use LiveSupWeb, :view
  alias LiveSup.Schemas.User

  def signup_from_external_provider?(user) do
    user
    |> User.external_provider?()
  end
end
