defmodule Fstdt.BannedIpsSchema do
  @moduledoc """
  table: banned_IPs
    contains banned ip addresses and address ranges
    supports wildcards ? and *
    set date expires to 0000/00/00 00:00 for permaban ?
  """
  use Ecto.Schema
  schema "banned_ips" do
    field :address, :string, nil: false
    field :date_banned, :utc_datetime, nil: false
    field :date_expires, :utc_datetime, nil: false
    belongs_to :banned_by, Fstdt.UsersSchema
    field :remarks, :string, nil: true
  end
end
