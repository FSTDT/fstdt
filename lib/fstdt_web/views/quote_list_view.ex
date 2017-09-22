defmodule FstdtWeb.QuoteListView do
  use FstdtWeb, :view

  def page_title(:show_new, %{topic: topic}) do
    topic
  end
end
