defmodule FstdtWeb.QuoteListView do
  use FstdtWeb, :view

  def page_title(:show_new, %{category: %{name: name}}) do
    name
  end
end
