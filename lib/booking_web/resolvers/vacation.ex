defmodule BookingWeb.Resolvers.Vacation do
  alias Booking.Vacation
  alias BookingWeb.Schema.ChangesetErrors

  def list_places(_, args, _) do
    places = Vacation.list_places(args)
    {:ok, places}
  end

  def get_place_by_slug(_, %{slug: slug}, _) do
    case Booking.Vacation.get_place_by_slug(slug) do
      nil -> {:error, "Place not found"}
      place -> {:ok, place}
    end
  end

  def list_place_bookings(place, _, _) do
    bookings = Booking.Vacation.list_bookings_for_place(place)
    {:ok, bookings}
  end

  def create_booking(_, attrs, %{context: %{current_user: user}}) do
    case Vacation.create_booking(user, attrs) do
      {:ok, booking} ->
        {:ok, booking}

      {:error, changeset} ->
        {:error,
         message: "Could not create booking", details: ChangesetErrors.errors_details(changeset)}
    end
  end

  def cancel_booking(_, %{booking_id: booking_id}, %{context: %{current_user: user}}) do
    booking = Vacation.get_booking(booking_id)

    if booking.user_id != user.id do
      {:error, "Unauthorized to cancel this booking"}
    else
      case Booking.Vacation.cancel_booking(booking) do
        {:ok, canceled_booking} ->
          {:ok, canceled_booking}

        {:error, changeset} ->
          {:error,
           message: "Could not cancel booking", details: ChangesetErrors.errors_details(changeset)}
      end
    end
  end

  def create_review(_, %{review: review_params}, %{context: %{current_user: user}}) do
    case Booking.Vacation.create_review(user, review_params) do
      {:ok, review} ->
        {:ok, review}

      {:error, changeset} ->
        {:error,
         message: "Could not create review", details: ChangesetErrors.errors_details(changeset)}
    end
  end
end
