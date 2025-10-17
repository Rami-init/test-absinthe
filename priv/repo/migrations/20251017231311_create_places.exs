defmodule Booking.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :slug, :string
      add :description, :string
      add :location, :string
      add :price_per_night, :decimal
      add :image, :string
      add :image_thumbnail, :string
      add :max_guests, :integer
      add :pet_friendly, :boolean, default: false, null: false
      add :pool, :boolean, default: false, null: false
      add :wifi, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:places, [:slug])
    create unique_index(:places, [:name])
  end
end
