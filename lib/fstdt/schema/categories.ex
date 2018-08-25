defmodule Fstdt.Schema.Categories do
  @moduledoc """
  Fundie / Sexist / etc
  """
  use Ecto.Schema
  schema "categories" do
    field :name, :string, nil: false
    field :abbreviation, :string, nil: false
    field :description, :string, nil: false
  end
end