defmodule LiveSup.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{TeamMember, Link}

  @default_location %{
    "timezone" => "Europe/Madrid",
    "city" => "Es Castell",
    "state" => "Balearic Islands",
    "country" => "Spain",
    "zip_code" => "07720",
    "lat" => 39.9991163,
    "lng" => 3.8389047
  }

  @livesup_bot_identifier "livesup_bot"

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  @derive {Inspect, except: [:password]}
  schema "users" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:avatar_url, :string)
    field(:provider, :string)
    field(:password, :string, virtual: true)
    field(:hashed_password, :string, redact: true)
    field(:confirmed_at, :naive_datetime)
    field(:state, :string)
    field(:system_identifier, :string)
    field(:system, :boolean, default: false)

    field(:location, :map, default: @default_location)

    field(:settings, :map)

    timestamps()

    has_many(:team_members, TeamMember)
    has_many(:links, Link)
    has_many(:teams, through: [:team_members, :teams])
  end

  @optional_fields [
    :email,
    :password,
    :first_name,
    :last_name,
    :avatar_url,
    :location,
    :settings,
    :provider,
    :state,
    :system,
    :system_identifier
  ]

  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @optional_fields)
    |> validate_required([])
    |> validate_email()
    |> validate_password(opts)
    |> maybe_set_location()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :first_name,
      :last_name,
      :avatar_url,
      :location,
      :settings,
      :provider,
      :state
    ])
    |> validate_required([])
    |> validate_email()
    |> maybe_set_location()
  end

  def internal_registration_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :id,
      :email,
      :first_name,
      :last_name,
      :avatar_url,
      :location,
      :settings,
      :provider,
      :state,
      :system,
      :system_identifier
    ])
    |> validate_required([])
    |> validate_email()
    |> maybe_set_location()
  end

  def onboarded_state, do: "onboarded"
  def onboarded?(%__MODULE__{state: state}), do: state == onboarded_state()

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, LiveSup.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_set_location(%Ecto.Changeset{data: %__MODULE__{location: nil}} = changeset) do
    changeset
    |> put_change(:location, default_location())
  end

  defp maybe_set_location(%Ecto.Changeset{data: %__MODULE__{location: _location}} = changeset),
    do: changeset

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%LiveSup.Schemas.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def default_avatar_url(%__MODULE__{avatar_url: avatar_url}) do
    avatar_url || "/images/default-user-avatar.png"
  end

  def location(%__MODULE__{location: location}) do
    location || default_location()
  end

  def address(%__MODULE__{location: location}) do
    "#{location["state"]}, #{location["country"]}"
  end

  def address_point(%__MODULE__{location: location}) do
    "#{location["lat"]}, #{location["lng"]}"
  end

  def default_location(), do: @default_location

  def external_provider?(%__MODULE__{provider: nil}), do: false
  def external_provider?(%__MODULE__{provider: _}), do: true

  def default_bot_identifier, do: @livesup_bot_identifier
end
