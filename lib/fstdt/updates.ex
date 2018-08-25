defmodule Fstdt.Updates do
  @moduledoc """
  Changesets and update calls.
  """
  import Ecto.Changeset

  def set_account_type_changeset(account = %Fstdt.Schema.Accounts{}, params) do
    account
    |> cast(params, [:account_type])
    |> validate_required([:account_type])
  end

  def set_account_type_changeset(user = %Fstdt.Schema.Users{}, params) do
    set_account_type_changeset(Fstdt.Repo.preload(user, :account).account, params)
  end

  def create_quote_changeset(params) do
    %Fstdt.Schema.Quotes{}
    |> cast(params, [:url_original, :text, :is_submitter_visible])
    |> quote_changeset_put_categories(params)
    |> quote_changeset_put_site_name(params)
    |> quote_changeset_put_fundie(params)
    |> quote_changeset_put_submitter(params)
    |> cast(%{"text_html" => convert_text_to_html(params["text"])}, [:text_html])
    |> validate_required([:submitter, :fundie, :site_name, :categories, :url_original, :text])
  end
  def quote_changeset_put_categories(changeset, %{"categories" => categories}) when categories != [] do
    put_assoc(changeset, :categories, Enum.map(categories, &Fstdt.Queries.category_by_abbrev/1))
  end
  def quote_changeset_put_categories(changeset, _), do: changeset

  def quote_changeset_put_site_name(changeset, %{"site_name" => name}) when name != "" do
    put_assoc(changeset, :site_name, get_or_insert_site_name(name))
  end
  def quote_changeset_put_site_name(changeset, _), do: changeset

  def quote_changeset_put_fundie(changeset, %{"fundie" => name}) when name != "" do
    put_assoc(changeset, :fundie, get_or_insert_fundie(name))
  end
  def quote_changeset_put_fundie(changeset, _), do: changeset

  def quote_changeset_put_submitter(changeset, %{"submitter" => name}) when name != "" do
    put_assoc(changeset, :submitter, get_or_insert_submitter(name))
  end
  def quote_changeset_put_submitter(changeset, _), do: changeset

  def create_site_name_changeset(params) do
    %Fstdt.Schema.SiteNames{}
    |> cast(params, [:name, :normalized])
    |> validate_required([:name, :normalized])
  end

  def get_or_insert_site_name(name) do
    Fstdt.Schema.SiteNames
    |> Fstdt.Repo.get_by(normalized: name)
    |> case do
      nil ->
        %{name: name, normalized: name}
        |> create_site_name_changeset()
        |> Fstdt.Repo.insert!()
      site_name -> site_name
    end
  end

  def create_fundie_changeset(params) do
    %Fstdt.Schema.Fundies{}
    |> cast(params, [:name, :normalized])
    |> validate_required([:name, :normalized])
  end

  def get_or_insert_fundie(name) do
    Fstdt.Schema.Fundies
    |> Fstdt.Repo.get_by(normalized: name)
    |> case do
         nil ->
           %{name: name, normalized: name}
           |> create_fundie_changeset()
           |> Fstdt.Repo.insert!()
         fundie -> fundie
       end
  end

  def create_submitter_changeset(params) do
    %Fstdt.Schema.Users{}
    |> cast(params, [:username, :normalized])
    |> cast(%{is_registered: false}, [:is_registered])
    |> validate_required([:username, :normalized])
  end

  def get_or_insert_submitter(name) when is_binary(name) do
    Fstdt.Schema.Users
    |> Fstdt.Repo.get_by(normalized: name)
    |> case do
         nil ->
           %{username: name, normalized: name}
           |> create_submitter_changeset()
           |> Fstdt.Repo.insert!()
         user -> user
       end
  end

  def get_or_insert_submitter(%Fstdt.Schema.Users{} = user) do
    user
  end

  def convert_text_to_html(nil) do
    nil
  end
  def convert_text_to_html(text) do
    {:ok, html} = Rundown.convert(FstdtWeb.Endpoint.url, text)
    html
  end

  def nonce_to_string(nonce \\ :random)
  def nonce_to_string(:random), do: nonce_to_string(:rand.uniform(4294967296))
  def nonce_to_string(nonce), do: Integer.to_string(nonce, 32)

  def nonce_to_integer(nonce \\ :random)
  def nonce_to_integer(:random), do: nonce_to_integer(:rand.uniform(4294967296))
  def nonce_to_integer(nonce), do: String.to_integer(nonce, 32)
end
