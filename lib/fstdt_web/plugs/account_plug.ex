defmodule FstdtWeb.AccountPlug do
  @moduledoc """
  Check if a user is logged in.

  This plug must be run after the Phoenix Session variables are loaded,
  because the `account_id` is stored in there.

  ## Options

    * account_type: Defaults to `:noob`. See `Fstdt.Schema.AccountType`.

  ## Usage

  The recommended way to use this plug is to put it at the head of a Controller module,
  like this:

      # All of PubAdmin gets limited to people with Leader permissions.
      plug FstdtWeb.AccountPlug, account_type: :leader

  Within areas like templates and random permission-specific logic,
  you can access the user info like this:

      <%= @conn.assigns.account.username %>
  """

  import Plug.Conn
  alias Fstdt.Schema.AccountType

  @session_variable_name :account_id
  @assign_name :account

  def init(options \\ %{})
  def init(options) when is_map(options) do
    %{account_type: :noob}
    |> Map.merge(options)
  end
  def init(options) when is_list(options) do
    options
    |> Map.new()
    |> init()
  end

  def call(conn, %{account_type: required_account_type}) do
    account_id = Plug.Conn.get_session(conn, @session_variable_name)
    maybe_assign_account(conn, required_account_type, account_id)
  end

  def maybe_assign_account(conn, :anon, nil) do
    conn
  end
  def maybe_assign_account(_conn, _, nil) do
    raise FstdtWeb.PermissionDeniedError
  end
  def maybe_assign_account(conn, required_account_type, account_id) do
    account = Fstdt.Repo.get!(Fstdt.Schema.Accounts, account_id)
    if AccountType.gt?(required_account_type, account.account_type) do
      raise FstdtWeb.PermissionDeniedError
    end
    assign(conn, @assign_name, account)
  end
end
