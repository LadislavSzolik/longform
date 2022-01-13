defmodule Longform.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :type, :string
      add :addr_str, :string
      add :addr_nr, :integer
      add :addr_city, :string
      add :addr_pc, :integer
      add :addr_cntry, :string

      timestamps()
    end
  end
end
