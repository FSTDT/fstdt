defmodule Fstdt.Repo.Migrations.Init do
  use Ecto.Migration

  defp convert_sql_file_to_sql_statements(sql) do
    sql
    |> String.replace(~r{\/\*.*?\*\/}s, "", global: true)
    |> String.replace(~r{--.*$}m, "", global: true)
    |> String.split("$$")
    |> split_sql_()
    |> Enum.map(fn item ->
      item
      |> String.replace(~r/(\s|\n)+/s, " ", global: true)
      |> String.replace(~r/^ /, "", global: true)
      |> String.replace(~r/ $/, "", global: true)
    end)
  end

  defp split_sql_([before_quote, in_quote, after_quote | remainder]) do
    [first_part_of_quote | before_quote_parts_reversed] = before_quote
     |> String.split(";")
     |> :lists.reverse()
    [last_part_of_quote | after_quote_parts] = after_quote
     |> String.split(";")
    quoted_part = "#{first_part_of_quote}$$#{in_quote}$$#{last_part_of_quote}"
    :lists.reverse(before_quote_parts_reversed)
     ++ [quoted_part]
     ++ after_quote_parts
     ++ split_sql_(remainder)
  end
  defp split_sql_([unquoted]) do
    unquoted |> String.split(";")
  end
  defp split_sql_([]) do
    []
  end

  defp run_sql(name) do
    {:ok, sql} = :fstdt
    |> :code.priv_dir()
    |> Path.join("repo/migrations/sql/" <> name)
    |> File.read()
    sql
    |> convert_sql_file_to_sql_statements()
    |> Enum.each(fn 
        "\\i " <> file -> run_sql(file)
        "" -> :ok
        statement -> execute(statement)
    end)
  end

  def up do
    run_sql("init_up.sql")
  end

  def down do
    run_sql("init_down.sql")
  end
end
