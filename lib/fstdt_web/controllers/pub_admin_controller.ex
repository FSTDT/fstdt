defmodule FstdtWeb.PubAdminController do
  use FstdtWeb, :controller
  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :admin

  def index(conn, %{}) do
    case Fstdt.SubmissionQueue.peek_quote() do
      {nonce, quote_} ->
        render conn, "index.html", %{
          quote_: quote_,
          nonce: Fstdt.Updates.nonce_to_string(nonce),
        }
      nil ->
        conn
        |> put_flash(:ok, "No new quotes to review!")
        |> redirect(to: index_path(conn, :index))
    end
  end

  def review(conn, %{"nonce" => nonce, "disposition" => disposition}) do
    quote = Fstdt.SubmissionQueue.pop_quote(Fstdt.Updates.nonce_to_integer(nonce))
    conn = case disposition do
      "approve" ->
        quote
        |> Ecto.Changeset.change()
        |> Fstdt.Repo.insert!()
        put_flash(conn, :ok, "Accepted quote")
      _ ->
        put_flash(conn, :error, "Rejected quote")
    end
    redirect(conn, to: pub_admin_path(conn, :index))
  end
end
