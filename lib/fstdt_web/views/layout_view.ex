defmodule FstdtWeb.LayoutView do
  use FstdtWeb, :view

  @doc """
  Grabs the page title; that is, the contents of the `<title>` tag.

  Based on the code from 
  <http://sevenseacat.net/posts/2015/page-specific-titles-in-phoenix/>.

  To add a custom page title for an existing view, write something like this:

      def page_title(:show, %{author: %{name: author}, site: %{name: site}}) do
        "\#{author}, \#{site}"
      end

  You can also add a custom description the same way:

      def page_description(:show, _params) do
        "An archive of the most hillarious, evil, and incomprehensible \
        quotes on the net."
      end
  """
  def page_meta(conn, assigns, tag, default) do
    import Phoenix.Controller, only: [view_module: 1, action_name: 1]
    try do
      apply(view_module(conn), tag, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default
    end
  end
end
