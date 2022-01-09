defmodule LongformWeb.MultiPageForm do
  use LongformWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
    <h1>New property</h1>
    <.live_component module={LongformWeb.Components.FormStep1} id={1} />
    </div>
    """
  end
end
