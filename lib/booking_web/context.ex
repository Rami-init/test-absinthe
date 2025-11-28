defmodule BookingWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Booking.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    # Decode the base64 token
    case Base.decode64(token) do
      {:ok, decoded_token} ->
        # Get user by session token - returns {user, inserted_at} tuple
        case Accounts.get_user_by_session_token(decoded_token) do
          nil -> {:error, "invalid authorization token"}
          {user, _inserted_at} -> {:ok, user}
        end

      :error ->
        {:error, "invalid token format"}
    end
  end
end
