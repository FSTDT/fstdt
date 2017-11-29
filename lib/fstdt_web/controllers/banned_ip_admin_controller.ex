defmodule FstdtWeb.BannedIpAdminController do
  use FstdtWeb, :controller

  plug FstdtWeb.TrackingPlug, generate_id: true
  plug FstdtWeb.AccountPlug, account_type: :mod

  def index(conn, _params) do
    render_index(conn, add_changeset(%{}))
  end

  def render_index(conn, changeset) do
    render conn, "index.html",
      # banned_ips: Fstdt.Repo.all(Fstdt.BannedIpsSchema),
      changeset: changeset
  end

  def add(conn, %{"banned_ip" => %{"address" => address, "date_expires" => date_expires, "remarks" => remarks}}) do
    %{address: address, date_expires: date_expires, remarks: remarks}
    |> add_changeset()
    |> Fstdt.Repo.insert()
    |> case do
      {:ok, _banned_ip} ->
        conn
        |> put_flash(:ok, "Added banned IP")
        |> redirect(to: banned_ip_admin_path(conn, :index))
      {:error, changeset} ->
        IO.inspect(changeset)
        conn
        |> put_status(400)
        |> put_flash(:error, "Cannot add banned IP")
        |> render_index(changeset)
    end
  end

  def add_changeset(params) do
    import Ecto.Changeset
    params = Map.merge(%{
      date_banned: DateTime.utc_now(),
      banned_by_id: 1, # TODO: pull this from the environment
    }, params)
    #%Fstdt.BannedIpsSchema{}
    #|> cast(params, [:address, :date_banned, :date_expires, :remarks, :banned_by_id])
    #|> validate_required([:address, :date_banned, :date_expires, :banned_by_id])
  end

  def delete(conn, %{"id" => id}) do
    import Ecto.Query
    Fstdt.Repo.delete_all(from(b in Fstdt.BannedIpsSchema, where: b.id == ^id))
    |> case do
      {1, _} ->
        conn
        |> put_flash(:ok, "Removed banned IP")
        |> redirect(to: banned_ip_admin_path(conn, :index))
      {0, _} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Cannot remove banned IP")
        |> render_index(add_changeset(%{}))
    end
  end
end
