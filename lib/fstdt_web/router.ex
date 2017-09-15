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

    get "/", IndexController, :index
    get "/search", SearchController, :search
  end

  # Example URLs:
  # - http://fstdt.org/l/fstdt/commented/
  #   Show fundamentalist quotes starting from the most recently commented
  # - http://fstdt.org/l/cstdt/2016/01/
  #   For January of 2016, show Conspiracy quotes in reverse-chronological order
  # - http://fstdt.org/l/cstdt/2016/01/
  #   For January of 2016, show Conspiracy quotes in reverse-chronological order
  # - http://fstdt.org/l/
  #   Show all topics (currently FSTDT, CSTDT, RSTDT, and SSTDT)
  scope "/l/", FstdtWeb do
    pipe_through :browser

    get "/", QuoteListController, :index
    get "/:topic/", QuoteListController, :show_new
    get "/:topic/:year/", QuoteListController, :dates
    get "/:topic/:year/:month", QuoteListController, :show_old
    get "/:topic/commented", QuoteListController, :show_recently_commented
    get "/:topic/random", QuoteListController, :show_random
    get "/:topic/top", QuoteListController, :show_top
  end

  scope "/submit/", FstdtWeb do
    get "/", QuoteSubmitController, :index
    # The :submission ID is a UUID generated as part of the submit form.
    # It is used to detect duplicate submissions,
    # and does not need to be kept forever.
    # No error should be shown to the user if a duplicate is detected;
    # if their connection is flaky, that's fine.
    put "/:submission", QuoteSubmitController, :submit
  end

  scope "/q/", FstdtWeb do
    pipe_through :browser

    get "/:quote/", QuotePageController, :show
    put "/:quote/comments/:submission", CommentSubmitController, :submit
  end

  scope "/admin/", FstdtWeb do
    pipe_through :browser

    get "/", PubAdminController, :index
    post "/", PubAdminController, :review
    put "/q/:quote", QuoteAdminController, :edit
    delete "/q/:quote", QuoteAdminController, :delete
    put "/c/:comment", CommentAdminController, :edit
    delete "/c/:comment", CommentAdminController, :delete
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
