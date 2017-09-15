defmodule FstdtWeb.LegacyController do
  use FstdtWeb, :controller

  def default(conn, _params) do
    redirect(conn, to: index_path(conn, :index))
  end

  def faq(conn, _params) do
    render conn, "todo.html", items: %{page: :faq}
  end

  def pub_admin(conn, _params) do
    render conn, "todo.html", items: %{page: :pub_admin}
  end

  def quote(conn, %{"QID" => legacy_id}) do
    render conn, "todo.html", items: %{legacy_id: legacy_id}
  end
  def quote(conn, _params) do
    conn
    |> put_status(:not_found)
    |> render(FstdtWeb.ErrorView, :'404')
  end

  def archive(conn, %{"Archive" => legacy_id}) do
    archive_(conn, legacy_id)
  end
  def archive(conn, _params) do
    archive_(conn, "1")
  end

  def archive_(conn, legacy_id) do
    render conn, "todo.html", items: %{legacy_id: legacy_id}
  end

  def random_quotes(conn, %{"Archive" => legacy_id}) do
    random_quotes_(conn, legacy_id)
  end
  def random_quotes(conn, _params) do
    random_quotes_(conn, "1")
  end

  def random_quotes_(conn, legacy_id) do
    render conn, "todo.html", items: %{legacy_id: legacy_id}
  end

  def latest_comments(conn, %{"Archive" => legacy_id}) do
    latest_comments_(conn, legacy_id)
  end
  def latest_comments(conn, _params) do
    latest_comments_(conn, "1")
  end

  def latest_comments_(conn, legacy_id) do
    render conn, "todo.html", items: %{legacy_id: legacy_id}
  end

  def top(conn, %{"Archive" => legacy_id}) do
    top_(conn, legacy_id)
  end
  def top(conn, _params) do
    top_(conn, "1")
  end

  def top_(conn, legacy_id) do
    render conn, "todo.html", items: %{legacy_id: legacy_id}
  end

  def search(conn, params) do
    criteria = params
    |> Enum.flat_map(fn
      {"Archive", legacy_id} -> [{:archive_legacy_id, legacy_id}]
      {"Fundie", name} -> [{:quote_fundie_by_name, name}]
      {"Quote", keywords} -> [{:quote_by_keywords, keywords}]
      {"Board", name} -> [{:quote_board_by_name, name}]
      {"Author", name} -> [{:comment_author_by_name, name}]
      {"Comment", keywords} -> [{:comment_by_keywords, keywords}]
      _ -> []
    end)
    |> case do
      [] -> %{search: :top_level}
      criteria -> Map.new(criteria)
    end
    render conn, "todo.html", items: criteria
  end
end
