defmodule Longform.PropertiesTest do
  use Longform.DataCase

  alias Longform.Properties

  describe "properties" do
    alias Longform.Properties.Property

    import Longform.PropertiesFixtures

    @invalid_attrs %{addr_city: nil, addr_cntry: nil, addr_nr: nil, addr_pc: nil, addr_str: nil, type: nil}

    test "list_properties/0 returns all properties" do
      property = property_fixture()
      assert Properties.list_properties() == [property]
    end

    test "get_property!/1 returns the property with given id" do
      property = property_fixture()
      assert Properties.get_property!(property.id) == property
    end

    test "create_property/1 with valid data creates a property" do
      valid_attrs = %{addr_city: "some addr_city", addr_cntry: "some addr_cntry", addr_nr: 42, addr_pc: 42, addr_str: "some addr_str", type: "some type"}

      assert {:ok, %Property{} = property} = Properties.create_property(valid_attrs)
      assert property.addr_city == "some addr_city"
      assert property.addr_cntry == "some addr_cntry"
      assert property.addr_nr == 42
      assert property.addr_pc == 42
      assert property.addr_str == "some addr_str"
      assert property.type == "some type"
    end

    test "create_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Properties.create_property(@invalid_attrs)
    end

    test "update_property/2 with valid data updates the property" do
      property = property_fixture()
      update_attrs = %{addr_city: "some updated addr_city", addr_cntry: "some updated addr_cntry", addr_nr: 43, addr_pc: 43, addr_str: "some updated addr_str", type: "some updated type"}

      assert {:ok, %Property{} = property} = Properties.update_property(property, update_attrs)
      assert property.addr_city == "some updated addr_city"
      assert property.addr_cntry == "some updated addr_cntry"
      assert property.addr_nr == 43
      assert property.addr_pc == 43
      assert property.addr_str == "some updated addr_str"
      assert property.type == "some updated type"
    end

    test "update_property/2 with invalid data returns error changeset" do
      property = property_fixture()
      assert {:error, %Ecto.Changeset{}} = Properties.update_property(property, @invalid_attrs)
      assert property == Properties.get_property!(property.id)
    end

    test "delete_property/1 deletes the property" do
      property = property_fixture()
      assert {:ok, %Property{}} = Properties.delete_property(property)
      assert_raise Ecto.NoResultsError, fn -> Properties.get_property!(property.id) end
    end

    test "change_property/1 returns a property changeset" do
      property = property_fixture()
      assert %Ecto.Changeset{} = Properties.change_property(property)
    end
  end
end
