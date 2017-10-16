defmodule Fstdt.Repo.Migrations.Init do
  use Ecto.Migration

  def up do
    {:ok, sql} = :fstdt
    |> :code.priv_dir()
    |> Path.join("repo/migrations/sql/init_up.sql")
    |> File.read()
    sql
    |> String.split(";")
    |> Enum.each(&execute/1)
  end

  def down do
    {:ok, sql} = :fstdt
    |> :code.priv_dir()
    |> Path.join("repo/migrations/sql/init_down.sql")
    |> File.read()
    sql
    |> String.split(";")
    |> Enum.each(&execute/1)
  end
end
