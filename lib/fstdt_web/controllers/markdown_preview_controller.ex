defmodule FstdtWeb.MarkdownPreviewController do
  use FstdtWeb, :controller

  def preview(conn, %{"url" => url, "contents" => contents}) do
    {:ok, html} = Rundown.convert(url, contents)
    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, html)
  end
end
