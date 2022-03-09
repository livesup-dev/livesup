defmodule LiveSupWeb.Plugs.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :live_sup

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
