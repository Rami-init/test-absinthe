defmodule Booking.Vacation.VacationBooking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :start_date, :date
    field :end_date, :date
    field :state, :string
    field :total_price, :decimal

    belongs_to :place, Booking.Vacation.Place, foreign_key: :place_id
    belongs_to :user, Booking.Accounts.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(booking, attrs, user_scope) do
    booking
    |> cast(attrs, [:start_date, :end_date, :state, :total_price, :place_id])
    |> put_change(:state, Map.get(attrs, :state, "pending"))
    |> validate_required([:start_date, :end_date, :place_id])
    |> validate_inclusion(:state, ["pending", "confirmed", "cancelled"])
    |> put_change(:user_id, user_scope.user.id)
  end
end
