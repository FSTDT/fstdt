defmodule FstdtWeb.BannedContentAdminController do
  use FstdtWeb, :controller

  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :mod

  def index(conn, _params) do
    render_index(conn, add_changeset(%{}))
  end

  def render_index(conn, changeset) do
    render conn, "index.html",
      banned_content: Fstdt.Repo.all(Fstdt.Schema.BannedContent),
      changeset: changeset
  end

  def add(conn, %{"banned_content" => content}) do
    content
    |> add_changeset()
    |> Fstdt.Repo.insert()
    |> case do
      {:ok, _banned_content} ->
        conn
        |> put_flash(:ok, "Added ban line")
        |> redirect(to: banned_content_admin_path(conn, :index))
      {:error, changeset} ->
        IO.inspect(changeset)
        conn
        |> put_status(400)
        |> put_flash(:error, "Cannot add ban line")
        |> render_index(changeset)
    end
  end

  def add_changeset(params) do
    import Ecto.Changeset
    %Fstdt.Schema.BannedContent{}
    |> cast(params, [
      :text,
      :is_ip_address,
      :is_comment_text,
      :is_quote_text,
      :is_sotdt_text,
      :is_issues_text,
      :is_fundie,
      :is_site,
      :is_url,
      :is_useragent,
      :is_username,
      :is_password,
      :is_email,
      :is_shadowbanned,
      :expires,
      :date_expires,
    ])
    |> validate_required([:text, :date_expires])
  end

  def delete(conn, %{"id" => id}) do
    import Ecto.Query
    Fstdt.Repo.delete_all(from(b in Fstdt.Schema.BannedContent, where: b.id == ^id))
    |> case do
      {1, _} ->
        conn
        |> put_flash(:ok, "Removed ban line")
        |> redirect(to: banned_content_admin_path(conn, :index))
      {0, _} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Cannot remove ban line")
        |> render_index(add_changeset(%{}))
    end
  end
end
