defmodule LongformWeb.New do
  use LongformWeb, :live_view

  alias Longform.Properties
  alias Longform.Properties.Property

  @steps [:first, :second, :last]
  def mount(_params, _session, socket) do
    changeset = Properties.change_property(%Property{})

    socket = assign(socket, changeset: changeset, step: :first, formData: %Property{})
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
    <h1>New property</h1>
      <.form let={f} for={@changeset} phx-submit="save" >
        <%= show(@step, f) %>
        <div>
          <%= live_redirect "Cancel", to: Routes.live_path(@socket, LongformWeb.List) %>
          <%= if @step != prev_step(@step) do %>
            <button phx-click="back" type="button">Back</button>
          <% end %>

          <%= submit submit_text(@step) %>
        </div>
        </.form>
    </div>
    """
  end

  defp submit_text(:last) do
    "Submit"
  end

  defp submit_text(_) do
    "Next"
  end

  defp show(:first, form) do
    assigns = %{form: form}

    ~H"""
      <%= input_helper(:type, form) %>
    """
  end

  defp show(:second, form) do
    assigns = %{form: form}

    ~H"""
      <%= input_helper(:addr_str, form) %>
    """
  end

  defp show(:last, form) do
    assigns = %{form: form}

    ~H"""
    <%= input_helper(:addr_str, form) %>
    <%= input_helper(:addr_nr, form) %>
    <%= input_helper(:addr_city, form) %>
    <%= input_helper(:addr_pc, form) %>
    <%= input_helper(:addr_cntry, form) %>
    """
  end

  defp input_helper(field, form) do
    assigns = %{field: field, form: form}

    ~H"""
      <div>
      <%= label @form, @field %>
      <%= text_input @form, @field %>
      <%= error_tag @form, @field %>
      </div>
    """
  end

  def handle_event("back", _, socket) do
    socket = update(socket, :step, fn step -> prev_step(step) end)
    {:noreply, socket}
  end

  def handle_event("save", %{"property" => params}, socket) do
    %{step: step, formData: formData} = socket.assigns
    socket = process_step(step, formData, params, socket)
    {:noreply, socket}
  end

  defp process_step(:last, formData, params, socket) do
    case Properties.create_property(formData, params) do
      {:ok, _property} ->
        push_redirect(socket,
          to: Routes.live_path(socket, LongformWeb.List),
          replace: true
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  defp process_step(step, formData, params, socket) do
    changeset = Properties.change_property(formData, params, step)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, property} ->
        next_step = next_step(step)
        assign(socket, step: next_step, changeset: changeset, formData: property)

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  # Changing steps

  defp next_step(step) do
    index = Enum.find_index(@steps, fn x -> x == step end)
    Enum.fetch!(@steps, index + 1)
  end

  defp prev_step(step) do
    index = Enum.find_index(@steps, fn x -> x == step end)
    Enum.fetch!(@steps, max(index - 1, 0))
  end
end
