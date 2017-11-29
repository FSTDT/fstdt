defmodule FstdtWeb.QuoteSubmitController do
  use FstdtWeb, :controller

  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :anon

  def index(conn, _) do
    render conn, "index.html",
      nonce: Integer.to_string(:rand.uniform(4294967296), 32) <> Integer.to_string(:rand.uniform(4294967296), 32)
  end
end
