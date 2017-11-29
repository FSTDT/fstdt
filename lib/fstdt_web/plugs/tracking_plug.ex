defmodule FstdtWeb.TrackingPlug do
  @moduledoc """
  Maintain tokens in the user-surveilance system.

  This value persists across logouts, so it can be effectively used as part of a ban.

  ## Options

    * generate_id: boolean :: If set to true, then a new ID will be generated if none exists.
      If set to false, or unset, this effectively disallows a route to be taken if the browser
      (or, more likely, spambot) does not accept cookies.
  """

  import Plug.Conn

  # Cryptographic salt:
  # This does not need to be secret (there's a side-wide "secret value" for that).
  # It exists to prevent the tracking cookie getting mixed with other things that need signed.
  @salt "Gia7IYXg"

  # Names:
  @cookie_name "fstdt_tracking"
  @assign_name :tracking_cookie_id

  # A session ID can live for two years (this is specified in seconds).
  # This effectively means that a user ban can last up to two years.
  # (assuming the user is too dumb to clear their cookies, which some trolls are)
  @max_age 60 * 60 * 24 * 365 * 2

  def init(options \\ %{})
  def init(options) when is_map(options) do
    %{generate_id: false}
    |> Map.merge(options)
  end
  def init(options) when is_list(options) do
    options
    |> Map.new()
    |> init()
  end

  def call(%Plug.Conn{req_cookies: %{@cookie_name => cookie}} = conn, _options) do
    conn
    |> Phoenix.Token.verify(@salt, cookie, max_age: @max_age)
    |> case do
      {:ok, session_id} -> assign(conn, @assign_name, session_id)
      _ -> send_resp(conn, 400, "invalid fstdt_tracking cookie; try clearing your cookies")
    end
  end
  def call(conn, %{generate_id: true}) do
    session_id = random_256_chars()
    token = Phoenix.Token.sign(conn, @salt, session_id)
    conn
    |> put_resp_cookie(@cookie_name, token, max_age: @max_age)
    |> assign(@assign_name, session_id)
  end
  def call(conn, _options) do
    send_resp(conn, 400, "please enable cookies in your browser, go back, reload, then try again")
  end

  def random_256_chars do
    Integer.to_string(:rand.uniform(4294967296), 32) <> Integer.to_string(:rand.uniform(4294967296), 32)
  end
end
