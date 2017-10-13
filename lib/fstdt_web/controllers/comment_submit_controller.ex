defmodule FstdtWeb.CommentSubmitController do
  use FstdtWeb, :controller

  def submit(conn, %{"quote" => q, "contents" => comment_markdown, "nonce" => n}) do
    canonical_url = quote_page_url(conn, :show, q)
    {:ok, comment_html} = Rundown.convert(canonical_url, comment_markdown)
    render conn, "submit.html",
      quote: %{id: q},
      nonce: n,
      comment_html: comment_html
  end
end
