defmodule Fstdt.Schema.Quotes do
  @moduledoc """
  Fundie Nonsense Storage is defined in this table
  """
  use Ecto.Schema
  schema "quotes" do
    belongs_to :submitter, Fstdt.Schema.Users
    belongs_to :fundie, Fstdt.Schema.Fundies
    belongs_to :site_name, Fstdt.Schema.SiteNames
    many_to_many :categories, Fstdt.Schema.Categories, join_through: "quotes_categories_link", join_keys: [quote_id: :id, category_id: :id]
    field :url_original, :string, nil: false
    field :url_content, :string, nil: false, default: ""
    field :url_mirror, :string, nil: false, default: ""
    field :is_image_post, :boolean, default: false, nil: false
    field :is_video_post, :boolean, default: false, nil: false
    field :text, :string, nil: false
    field :text_html, :string, nil: false, default: ""
    field :note_submitter, :string, nil: true
    field :note_submitter_html, :string, nil: true
    field :note_moderator, :string, nil: true
    field :note_moderator_html, :string, nil: true
    field :votes_yay, :integer, nil: false, default: 0
    field :votes_nay, :integer, nil: false, default: 0
    field :votes_total, :integer, nil: false, default: 0
    field :votes_calculated, :integer, nil: false, default: 0
    field :views_unique, :integer, nil: false, default: 0
    field :views_total, :integer, nil: false, default: 0
    field :is_submitter_visible, :boolean, nil: false, default: false
    field :is_visible, :boolean, nil: false, default: true
    field :is_thread_locked, :boolean, nil: false, default: false
    field :is_thread_visible, :boolean, nil: false, default: true
    field :use_yscodes, :boolean, nil: false, default: false
    timestamps()
  end
end