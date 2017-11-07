defmodule Fstdt.UsersSchema do
  @moduledoc """
  table: users
 
    since users can enter a name without being registered,
    this table is somewhat weird and a not of fields are missing "not null"s
    because they don't apply to unregistered users.

    should we split this table?
    id 0 := anonymous?

    also, account types:
    0: locked / banned username
    1: unregistered user
    2: registered user 
    3: registered user with pubadmin access
    4: mod
    5: admin
  """
  use Ecto.Schema
  schema "users" do
    field :username, :string, nil: false
    field :nlzd_name, :string, nil: true
    field :is_registered, :boolean, nil: false
    field :date_registered, :utc_datetime, nil: true
    field :email, :string, nil: true
    belongs_to :registration_ip, Fstdt.IpAddressesSchema
    field :pw_hash, :string, nil: true
    field :pw_salt, :string, nil: true
    field :account_type, :integer, nil: false
    field :submission_count, :integer, nil: false
    field :comment_count, :integer, nil: false
  end
end
