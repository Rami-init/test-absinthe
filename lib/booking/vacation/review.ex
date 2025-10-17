defmodule Booking.Vacation.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :rating, :integer
    field :comment, :string
    field :place_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(review, attrs, user_scope) do
    review
    |> cast(attrs, [:rating, :comment])
    |> validate_required([:rating, :comment])
    |> put_change(:user_id, user_scope.user.id)
  end
end
