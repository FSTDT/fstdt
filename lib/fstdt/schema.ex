defmodule Fstdt.Schema do
  @moduledoc """
  Exports and converts data between SQL and Elixir.
  """

  defmodule NormalizedTextType do
    @moduledoc """
    Normalized strings are used to find and deduplicate names that are "the same."

    This data type converts to NFD, and then strips out combining marks.
    Do not show these strings to users. Use them only to identify likely duplicates.
    """
    @behaviour Ecto.Type
    def type, do: :string
    def cast(text), do: {:ok, text}
    def load(text), do: {:ok, text}
    def dump(text) do
      {:ok, text |> String.normalize(:nfc) |> String.downcase()}
    end
  end

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
    def dump(:anon), do: {:ok, 0}
    def dump(:noob), do: {:ok, 1}
    def dump(:user), do: {:ok, 2}
    def dump(:leader), do: {:ok, 3}
    def dump(:mod), do: {:ok, 4}
    def dump(:admin), do: {:ok, 5}
    def dump(d) when is_integer(d), do: {:ok, d}
    def load(0), do: {:ok, :anon}
    def load(1), do: {:ok, :noob}
    def load(2), do: {:ok, :user}
    def load(3), do: {:ok, :leader}
    def load(4), do: {:ok, :mod}
    def load(5), do: {:ok, :admin}
    def load(_), do: :error
    def cast(data) when is_integer(data), do: load(data)
    def cast(data), do: {:ok, data}

    @doc "Check if `a` is greater than `b`"
    def gt?(a, b) do
      {:ok, a} = dump(a)
      {:ok, b} = dump(b)
      a > b
    end
  end

  defmodule BannedContent do
    @moduledoc """
    Names, IPs, and stuff that can't be posted.
    """
    use Ecto.Schema
    schema "banned_content" do
      field :text, Fstdt.Schema.NormalizedTextType, nil: false
      field :is_ip_address, :boolean, nil: false, default: false
      field :is_comment_text, :boolean, nil: false, default: false
      field :is_quote_text, :boolean, nil: false, default: false
      field :is_sotdt_text, :boolean, nil: false, default: false
      field :is_issues_text, :boolean, nil: false, default: false
      field :is_fundie, :boolean, nil: false, default: false
      field :is_site, :boolean, nil: false, default: false
      field :is_url, :boolean, nil: false, default: false
      field :is_useragent, :boolean, nil: false, default: false
      field :is_username, :boolean, nil: false, default: false
      field :is_password, :boolean, nil: false, default: false
      field :is_email, :boolean, nil: false, default: false
      field :is_shadowbanned, :boolean, nil: false, default: false
      field :expires, :boolean, nil: false, default: false
      field :date_expires, :utc_datetime, nil: true
    end
  end

  defmodule Users do
    @moduledoc """
    Deduplicated usernames, potentially registered.
    """
    use Ecto.Schema
    schema "users" do
      field :username, :string, nil: false
      field :normalized, Fstdt.Schema.NormalizedTextType, nil: false
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
      field :normalized, Fstdt.Schema.NormalizedTextType, nil: false
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