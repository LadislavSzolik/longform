defmodule LongformWeb.MultiPageForm do
  use LongformWeb, :live_view

  alias Longform.Properties
  alias Longform.Properties.Property

  @steps [:one, :two, :full]
  def mount(_params, _session, socket) do
    changeset = Properties.change_property(%Property{})

    socket = assign(socket, changeset: changeset, step: :one, formData: %Property{})
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
    <h1>New property</h1>
      <.form let={f} for={@changeset} phx-submit="save" >

        <%= show(@step, f) %>

        <div>
          <%= if @step != prevStep(@step) do %>
            <button phx-click="back" type="button">Back</button>
          <% end %>
          <%= submit "Submit" %>
        </div>
        </.form>

    </div>
    """
  end

  def handle_event("back", _, socket) do
    socket = update(socket, :step, fn step -> prevStep(step) end)
    {:noreply, socket}
  end

  def handle_event("save", %{"property" => params}, socket) do
    # how to make it simpler?
    # I can't use changes from changeset as those are only part of the data.
    %{step: step, formData: formData} = socket.assigns

    changeset = Properties.change_property(formData, params, step)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, property} ->
        nextStep = nextStep(step)

        if nextStep == :full do
          property = Map.from_struct(property)

          case Properties.create_property(property) do
            {:ok, _property} ->
              socket =
                push_redirect(socket,
                  to: Routes.live_path(socket, LongformWeb.List),
                  replace: true
                )

              {:noreply, socket}

            {:error, %Ecto.Changeset{} = changeset} ->
              socket = assign(socket, changeset: changeset)
              {:noreply, socket}
          end
        else
          socket = assign(socket, step: nextStep, changeset: changeset, formData: property)
          {:noreply, socket}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end

  defp nextStep(step) do
    index = Enum.find_index(@steps, fn x -> x == step end)
    Enum.fetch!(@steps, index + 1)
  end

  defp prevStep(step) do
    index = Enum.find_index(@steps, fn x -> x == step end)
    Enum.fetch!(@steps, max(index - 1, 0))
  end

  defp show(:one, form) do
    assigns = %{form: form}

    ~H"""
      <%= input_helper(:type, form) %>
    """
  end

  defp show(:two, form) do
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
end
