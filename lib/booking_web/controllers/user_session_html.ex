defmodule BookingWeb.UserSessionHTML do
  use BookingWeb, :html

  embed_templates "user_session_html/*"

  defp local_mail_adapter? do
    Application.get_env(:booking, Booking.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
