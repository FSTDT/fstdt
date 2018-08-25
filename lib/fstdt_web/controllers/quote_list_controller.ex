defmodule FstdtWeb.QuoteListController do
  use FstdtWeb, :controller

  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :anon

  def show_new(conn, %{"category" => category_abbrev} = args) do
    category = Fstdt.Queries.category_by_abbrev(category_abbrev)
    render conn, "quote_list.html",
      quotes: Fstdt.Queries.latest_quotes_by_category(category.id, args["before"]),
      category: category
  end
end
