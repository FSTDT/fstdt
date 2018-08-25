defmodule FstdtWeb.AuthController do
  use FstdtWeb, :controller

  # This controller should only be used with an existing login form
  plug FstdtWeb.TrackingPlug, generate_id: false
  plug FstdtWeb.AccountPlug, account_type: :anon

  def login(conn, %{"login" => %{"username" => username, "password" => password}}) do
    account = case Fstdt.Repo.get_by(Fstdt.Schema.Accounts, normalized: username) do
      nil ->
        user = %Fstdt.Schema.Users{
          username: username,
          normalized: username,
          is_registered: true,
        } |> Fstdt.Repo.insert!()
        %Fstdt.Schema.Accounts{
          user: user,
          user_id: user.id,
          username: username,
          normalized: username,
          password_hash: "",
          password_salt: "",
          registration_date: DateTime.utc_now(),
          registration_email: "",
          current_email: "",
          account_type: :noob,
        } |> Fstdt.Repo.insert!()
      account -> account
    end
    conn
    |> put_session(:account_id, account.id)
    |> put_flash(:error, "WARNING: actual authentication is not yet implemented")
    |> redirect(to: index_path(conn, :index))
  end

  def logout(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: index_path(conn, :index))
  end
end
