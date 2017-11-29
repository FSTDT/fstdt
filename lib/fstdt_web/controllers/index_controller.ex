defmodule FstdtWeb.IndexController do
  use FstdtWeb, :controller
  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :anon

  def index(conn, _params) do
    render conn, "index.html"
  end
end
