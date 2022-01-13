defmodule Longform.PropertiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Longform.Properties` context.
  """

  @doc """
  Generate a property.
  """
  def property_fixture(attrs \\ %{}) do
    {:ok, property} =
      attrs
      |> Enum.into(%{
        addr_city: "some addr_city",
        addr_cntry: "some addr_cntry",
        addr_nr: 42,
        addr_pc: 42,
        addr_str: "some addr_str",
        type: "some type"
      })
      |> Longform.Properties.create_property()

    property
  end
end
