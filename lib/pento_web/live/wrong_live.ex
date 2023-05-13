defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias Pento.Accounts
  require IEx

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       session_id: session["live_socket_id"],
       score: 0,
       message: "Make a guess:",
       time: time(),
       secret: :rand.uniform(10)
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
      <pre>
        <%= @current_user.email %> 
        <%= @session_id %> 
      </pre>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    secret = socket.assigns.secret |> Integer.to_string()

    {message, score} =
      case secret do
        ^guess -> {"Your guess: #{guess}. Correct! You win!", socket.assigns.score + 1}
        _ -> {"Your guess: #{guess}. Wrong. Guess again. ", socket.assigns.score - 1}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        time: time(),
        score: score
      )
    }
  end
end
