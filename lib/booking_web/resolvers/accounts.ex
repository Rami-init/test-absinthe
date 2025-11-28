defmodule BookingWeb.Resolvers.Accounts do
  alias Booking.Accounts
  alias BookingWeb.Schema.ChangesetErrors
  alias Booking.Accounts.UserToken

  def sign_up(_, %{email: email, password: password}, _) do
    case Accounts.sign_up(%{email: email, password: password}) do
      {:ok, user} ->
        token = Accounts.generate_user_session_token(user)
        {:ok, %{user: user, token: Base.encode64(token)}}

      {:error, changeset} ->
        {:error,
         message: "Could not create user", details: ChangesetErrors.errors_details(changeset)}
    end
  end

  def sign_in(_, %{email: email, password: password}, _) do
    user = Accounts.get_user_by_email_and_password(email, password)

    case user do
      nil ->
        {:error, message: "Invalid email or password"}

      user ->
        token = Accounts.generate_user_session_token(user)
        {:ok, %{user: user, token: Base.encode64(token)}}
    end
  end
end
