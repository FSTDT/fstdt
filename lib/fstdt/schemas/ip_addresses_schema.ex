defmodule Fstdt.IpAddressesSchema do
  @moduledoc """
  table: ip_addresses
    this will collect ip addresses from 
    submissions, quotes, comments, registrations, etc.
  """
  use Ecto.Schema
  schema "ip_addresses" do
    field :address, :string, nil: false
  end
end
