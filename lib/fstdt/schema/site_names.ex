defmodule Fstdt.Schema.SiteNames do
  @moduledoc """
  De-duplicate the names of fundies
  """
  use Ecto.Schema
  schema "site_names" do
    field :name, :string, nil: false
    field :normalized, Fstdt.Schema.NormalizedTextType, nil: false
  end
end