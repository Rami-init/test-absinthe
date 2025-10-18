defmodule Booking.Vacation.VacationBooking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :start_date, :date
    field :end_date, :date
    field :state, :string
    field :total_price, :decimal
    field :place_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(booking, attrs, user_scope) do
    booking
    |> cast(attrs, [:start_date, :end_date, :state, :total_price])
    |> validate_required([:start_date, :end_date, :state, :total_price])
    |> put_change(:user_id, user_scope.user.id)
  end
end
