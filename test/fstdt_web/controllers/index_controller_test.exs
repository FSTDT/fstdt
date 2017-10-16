defmodule FstdtWeb.IndexControllerTest do
  use FstdtWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Fundies"
  end
end
