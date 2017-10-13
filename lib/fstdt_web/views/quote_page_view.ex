defmodule FstdtWeb.QuotePageView do
  use FstdtWeb, :view

  def page_title(:show, %{quote: %{id: q}}) do
    "##{q}"
  end
end
