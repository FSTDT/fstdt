defmodule Fstdt.Schema.BannedContent do
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