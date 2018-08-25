defmodule Fstdt.Schema.Fundies do
  @moduledoc """
  Fundie Nonsense Storage is defined in this table
  """
  use Ecto.Schema
  schema "fundies" do
    field :name, :string, nil: false
    field :normalized, Fstdt.Schema.NormalizedTextType, nil: false
  end
end