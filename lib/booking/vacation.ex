defmodule Booking.Vacation do
  alias Booking.Repo
  alias Booking.Vacation.{Place, VacationBooking}

  def list_places() do
    Repo.all(Place)
  end

  def get_place_by_slug(slug) do
    Repo.get_by(Place, slug: slug)
  end

  def get_booking(id) do
    Repo.get!(VacationBooking, id)
  end
end
