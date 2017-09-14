defmodule FstdtWeb.Router do
  use FstdtWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FstdtWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # FSTDT is linked to. A lot. We are *not* going to break those old links.
  # Luckily, we don't have to; Phoenix has no problem with URLs that happen to end in .aspx.
  scope "/", FstdtWeb do
    pipe_through :browser

    get "/Default.aspx", LegacyController, :default
    get "/QuoteArchives.aspx", LegacyController, :quote
    get "/ArchiveListing.aspx", LegacyController, :archive
    get "/RandomQuotes.aspx", LegacyController, :random_quotes
    get "/LatestComments.aspx", LegacyController, :latest_comments
    get "/Top250.aspx", LegacyController, :top
    get "/Top100.aspx", LegacyController, :top
    get "/Search.aspx", LegacyController, :search
    get "/FAQ.aspx", LegacyController, :faq
    get "/PubAdmin.aspx", LegacyController, :pub_admin
  end

  # Other scopes may use custom stacks.
  # scope "/api", FstdtWeb do
  #   pipe_through :api
  # end
end
