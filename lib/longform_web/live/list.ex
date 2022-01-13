defmodule LongformWeb.List do
  use LongformWeb, :live_view

  alias Longform.Properties

  def mount(_params, _session, socket) do
    properties = Properties.list_properties()
    socket = assign(socket, properties: properties)
    {:ok, socket, temporary_assigns: [properties: []]}
  end

  def render(assigns) do
    ~H"""
    <%= for p <- @properties do %>
    <div class="my-2">
      <span><%= p.type %></span>
      <span><%= p.addr_city %></span>
      <span><%= p.addr_cntry %></span>
      <span><%= p.addr_nr %></span>
      <span><%= p.addr_pc %></span>
      <span><%= p.addr_str %></span>
    </div>
    <% end %>
    <%= live_redirect "New", to: Routes.live_path(@socket, LongformWeb.New) %>
    """
  end
end
