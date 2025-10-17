defmodule Booking.Vacation.Place do
  use Ecto.Schema
  import Ecto.Changeset

  schema "places" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :location, :string
    field :price_per_night, :decimal
    field :image, :string
    field :image_thumbnail, :string
    field :max_guests, :integer
    field :pet_friendly, :boolean, default: false
    field :pool, :boolean, default: false
    field :wifi, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:name, :slug, :description, :location, :price_per_night, :image, :image_thumbnail, :max_guests, :pet_friendly, :pool, :wifi])
    |> validate_required([:name, :slug, :description, :location, :price_per_night, :image, :image_thumbnail, :max_guests, :pet_friendly, :pool, :wifi])
    |> unique_constraint(:slug)
    |> unique_constraint(:name)
  end
end
