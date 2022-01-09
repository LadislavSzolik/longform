defmodule LongformWeb.Components.FormStep1 do
  use LongformWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def update(_assigns, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
    Hello from step 1
    </div>
    """
  end
end
