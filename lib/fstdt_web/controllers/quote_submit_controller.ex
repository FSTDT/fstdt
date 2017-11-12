defmodule FstdtWeb.QuoteSubmitController do
  use FstdtWeb, :controller

  def index(conn, _) do
    render conn, "index.html",
      nonce: Integer.to_string(:rand.uniform(4294967296), 32) <> Integer.to_string(:rand.uniform(4294967296), 32)
  end
end
