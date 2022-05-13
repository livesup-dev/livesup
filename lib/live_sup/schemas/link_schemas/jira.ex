defmodule LiveSup.Schemas.LinkSchemas.Jira do
  @derive Jason.Encoder
  @enforce_keys [:account_id]
  defstruct [:account_id]
end
