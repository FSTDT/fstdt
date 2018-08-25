defmodule Fstdt.Queries do
  @moduledoc false

  import Ecto.Query
  alias Fstdt.Repo
  alias Fstdt.Schema.Quotes
  alias Fstdt.Schema.Categories

  def latest_quotes_by_category(category_id, before_date \\ nil) do
    (from q in Quotes,
         order_by: [desc: q.inserted_at],
         preload: [:submitter, :fundie, :site_name, :categories],
         where: fragment("quote_in_category(?, ?)", q.id, ^category_id))
    |> filter_by_date(before_date)
    |> Fstdt.Repo.all()
  end

  def category_by_abbrev(category_abbrev) do
    Fstdt.Repo.get_by!(Categories, abbreviation: category_abbrev)
  end

  defp filter_by_date(query, nil) do
    query
  end
  defp filter_by_date(query, date) do
    query
    |> where([q], q.inserted_at < ^date)
  end
end
