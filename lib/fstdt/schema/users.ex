defmodule Fstdt.Schema.Users do
  @moduledoc """
  Deduplicated usernames, potentially registered.
  """
  use Ecto.Schema
  schema "users" do
    field :username, :string, nil: false
    field :normalized, Fstdt.Schema.NormalizedTextType, nil: false
    field :is_registered, :boolean, nil: false
    has_one :account, Fstdt.Schema.Accounts, foreign_key: :user_id
    timestamps()
  end
end