defmodule LiveSupWeb.Api.SessionJSON do
  def create(%{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        email: user.email
      },
      message:
        "You are successfully logged in! Add this token to authorization header to make authorized requests."
    }
  end

  def error(%{message: message}) do
    %{
      status: :not_found,
      data: %{},
      message: message
    }
  end
end
