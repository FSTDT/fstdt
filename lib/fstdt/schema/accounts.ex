defmodule Fstdt.Schema.Accounts do
  @moduledoc """
  Registered users are defined in this table.
  """
  use Ecto.Schema
  schema "accounts" do
    belongs_to :user, Fstdt.Schema.Users
    field :username, :string, nil: false
    field :normalized, Fstdt.Schema.NormalizedTextType, nil: false
    field :password_hash, :string, nil: false
    field :password_salt, :string, nil: false
    field :registration_date, :utc_datetime, nil: false
    # belongs_to :registration_session, Fstdt.Schema.Sessions
    field :registration_email, :string, nil: false
    field :current_email, :string, nil: false
    field :account_type, Fstdt.Schema.AccountType, nil: false
  end
end