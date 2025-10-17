defmodule BookingWeb.PageController do
  use BookingWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
