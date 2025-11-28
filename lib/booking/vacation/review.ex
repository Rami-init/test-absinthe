defmodule Booking.Vacation.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :rating, :integer
    field :comment, :string

    belongs_to :place, Booking.Vacation.Place, foreign_key: :place_id
    belongs_to :user, Booking.Accounts.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(review, attrs, user_scope) do
    review
    |> cast(attrs, [:rating, :comment, :place_id])
    |> validate_required([:rating, :comment, :place_id])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> put_change(:user_id, user_scope.user.id)
  end
end
