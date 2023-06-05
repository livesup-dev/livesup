defmodule LiveSup.Schemas.LinkSchemas.Github do
  @derive Jason.Encoder
  @enforce_keys [:username]
  defstruct [:username]
end
