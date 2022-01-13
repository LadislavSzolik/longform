defmodule Longform.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :addr_city, :string
    field :addr_cntry, :string
    field :addr_nr, :integer
    field :addr_pc, :integer
    field :addr_str, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(property, attrs, part \\ :last) do
    property
    |> cast(attrs, [:type, :addr_str, :addr_nr, :addr_city, :addr_pc, :addr_cntry])
    |> validate_part(part)
  end

  defp validate_part(changeset, :first) do
    changeset
    |> validate_required([:type])
  end

  defp validate_part(changeset, :second) do
    changeset
    |> validate_required([:addr_str])
  end

  defp validate_part(changeset, :last) do
    changeset
    |> validate_part(:first)
    |> validate_required([:addr_str, :addr_nr, :addr_city, :addr_pc, :addr_cntry])
  end
end
