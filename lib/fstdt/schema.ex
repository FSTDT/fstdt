defmodule Fstdt.Schema do
  @moduledoc """
  Exports and converts data between SQL and Elixir.
  """

  defmodule AccountType do
    @moduledoc """
    Custom Ecto data type for account-types.

    In the database, these are stored as numbers.
    But to the user, these should appear as named atoms.

    | Number | Name   | Description           |
    |--------|--------|-----------------------|
    |      0 | anon   | Heavily throttled     |
    |      1 | noob   | Temporarily throttled |
    |      2 | user   | Not trottled          |
    |      3 | leader | Can access PubAdmin   |
    |      4 | mod    | Can censor and edit   |
    |      5 | admin  | Can do anything       |
    """
    @behaviour Ecto.Type
    def type, do: :integer
    def cast(i) when is_integer(i), do: {:ok, i}
    def cast(:anon), do: {:ok, 0}
    def cast(:noob), do: {:ok, 1}
    def cast(:user), do: {:ok, 2}
    def cast(:leader), do: {:ok, 3}
    def cast(:mod), do: {:ok, 4}
    def cast(:admin), do: {:ok, 5}
    def cast(_), do: :error
    def load(0), do: {:ok, :anon}
    def load(1), do: {:ok, :noob}
    def load(2), do: {:ok, :user}
    def load(3), do: {:ok, :leader}
    def load(4), do: {:ok, :mod}
    def load(5), do: {:ok, :admin}
    def load(_), do: :error
    def dump(data), do: cast(data)

    @doc "Check if `a` is greater than `b`"
    def gt?(a, b) do
      {:ok, a} = cast(a)
      {:ok, b} = cast(b)
      a > b
    end
  end

  defmodule Users do
    @moduledoc """
    Deduplicated usernames, potentially registered.
    """
    use Ecto.Schema
    schema "users" do
      field :username, :string, nil: false
      # TODO: create a data type for Fstdt.Schema.Normalized
      field :normalized, :string, nil: false
      field :is_registered, :boolean, nil: false
      field :date_first_seen, :utc_datetime, nil: false
    end
  end

  defmodule Accounts do
    @moduledoc """
    Registered users are defined in this table.
    """
    use Ecto.Schema
    schema "accounts" do
      belongs_to :user, Fstdt.Schema.Users
      field :username, :string, nil: false
      # TODO: create a data type for Fstdt.Schema.Normalized
      field :normalized, :string, nil: false
      field :password_hash, :string, nil: false
      field :password_salt, :string, nil: false
      field :registration_date, :utc_datetime, nil: false
      # belongs_to :registration_session, Fstdt.Schema.Sessions
      field :registration_email, :string, nil: false
      field :current_email, :string, nil: false
      field :account_type, Fstdt.Schema.AccountType, nil: false
    end
  end
end