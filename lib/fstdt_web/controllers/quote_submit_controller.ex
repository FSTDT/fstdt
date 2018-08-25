defmodule FstdtWeb.QuoteSubmitController do
  use FstdtWeb, :controller

  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :anon

  def index(conn, _) do
    render(conn, "index.html",
      changeset: Fstdt.Updates.create_quote_changeset(%{}),
      nonce: Fstdt.Updates.nonce_to_string())
  end

  def submit(conn, %{"quote" => quote, "nonce" => nonce}) do
    nonce = Fstdt.Updates.nonce_to_integer(nonce)
    quote
    |> Fstdt.Updates.create_quote_changeset()
    |> Ecto.Changeset.apply_action(:insert)
    |> case do
         {:ok, data} ->
             Fstdt.SubmissionQueue.add_quote(nonce, data)
             redirect(conn, to: index_path(conn, :index))
         {:error, changeset} ->
             render(conn, "index.html",
                    changeset: changeset,
                    nonce: Fstdt.Updates.nonce_to_string())
    end

  end
end
